//
//  Exporter.swift
//  SlideShowMaker
//
//  Created by BCL Device7 on 31/10/22.
//

import UIKit
import CoreMedia
import MetalPetal

public protocol BCMExporterDelegate:AnyObject {
    func updateProgress(value:Float) -> Void
}

public class BCMExporter: NSObject {
    
    private var composition:BCMComposition!

    private var audioManager: BCMAudioManager?
    var width:Int = 1080, height:Int = 1080
    
    public weak var delegate:BCMExporterDelegate?
//    let FRAME_RATE:Float = 60
        
    private var assetWriter:BCMAssetWriter?
    
    private var reader:AVAssetReader?
    private var audiotrackReaderOutput:AVAssetReaderAudioMixOutput?
    private var presentTime = CMTime.zero

    private var bgImage : MTIImage!
    private var blendFilter : MTIBlendFilter!
    private var transformFilter : MTITransformFilter!
    private var frameTime : CMTime = .zero
    
    private var completion : ((Result<URL?, Error>?) -> Void)!
    private var mtiContext = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    public init(composition: BCMComposition,audioManager: BCMAudioManager? = nil) {
        super.init()
        self.composition = composition
        self.audioManager = audioManager
        
        width = Int(composition.renderSize.width)
        height = Int(composition.renderSize.height)
    }
    
    public func setComposition(composition: BCMComposition){
        self.composition = composition
        width = Int(composition.renderSize.width)
        height = Int(composition.renderSize.height)
    }
    
    
    public class func makeExportableSize(size: CGSize) -> CGSize{
        var width = Int(size.width)
        var height = Int(size.height)
        
        width =  width - (width % 16)
        height = height - (height % 16)
        
        return CGSize(width: width, height: height)
    }
    
    func setup() -> Void {
        
//        let maxQuality = getVideoQualitySize()
//        let tempSize = MTIMakeRect(aspectRatio: composition.renderSize, insideRect: CGRect(x: 0, y: 0, width: maxQuality.width, height: maxQuality.height)).size
        let tempSize = composition.renderSize
        

        
        
    }
    
    func setUpAudioReader() -> Void {
        
        guard let composition = audioManager?.getComposition() else {
            return
        }
        
        if reader?.status == .reading {
            reader?.cancelReading()
        }
        
        do {
            reader = try AVAssetReader(asset:composition)
        } catch  {
            print(error.localizedDescription)
        }
        
        let audioTracks = composition.tracks(withMediaType: .audio)
        guard audioTracks.count > 0 else {
            return
        }
        
        let audioSettings :[String : Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM
        ]
        
        audiotrackReaderOutput = AVAssetReaderAudioMixOutput(audioTracks: audioTracks, audioSettings: audioSettings)
        audiotrackReaderOutput?.audioMix = audioManager!.getAudioMix()

        reader?.add(audiotrackReaderOutput!)
        reader?.startReading()
    }
    
    public func export(withAudio: Bool,outputUrl: URL, completion: @escaping (Result<URL?, Error>?) -> Void) -> Void {
        
        assetWriter = BCMAssetWriter(outputSize: CGSize(width: width, height: height), outputUrl: outputUrl, withAudio: withAudio)
        assetWriter?.delegate = self
        assetWriter?.setVideoOptimizeForNetwork(value: shouldOptimizeVideoForNetwork())
        assetWriter?.mtiContext = self.mtiContext
        composition.resetProgress()
        
        frameTime = CMTimeMake(value: Int64((Double(composition.getDuration()) / Double( composition.getDuration() * Float(composition.getFrameRate()))) * 1000.0), timescale: 1000)
        
        if withAudio{
            setUpAudioReader()
        }
        
        presentTime = .zero
        self.completion = completion
        
        bgImage = MTIImage(color: MTIColor(red: 0, green: 0, blue: 0, alpha: 1), sRGB: false, size: CGSize(width: width, height: height))
        
        blendFilter = MTIBlendFilter(blendMode: .normal)
        blendFilter.inputImage = bgImage

        transformFilter = MTITransformFilter()
        transformFilter.viewport = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height))
        
        assetWriter?.startSession()
        assetWriter?.startAddingVideoSample()
        assetWriter?.startAddingAudioSample()
    }
    
    public func cancel(completion:@escaping (Result<URL?, Error>?) -> Void) -> Void {
        self.completion = nil
        assetWriter?.cancel(completion: completion)
    }
    
    func getVideoQualitySize() -> CGSize {
        let quality = UserDefaults.standard.integer(forKey: VIDEO_QUALITY)
        
        if quality == 0{
            return CGSize(width: 2048, height: 2048)         //2k
        }else if quality == 1{
            return CGSize(width: 1920, height: 1920)         // FULL HD
        }else{
            return CGSize(width: 1080, height: 1080)         // HD
        }
    }
    
    func shouldOptimizeVideoForNetwork() -> Bool {
        return UserDefaults.standard.integer(forKey: NETWORK_OPTIMIZATION) == 0 ? true : false
    }
    
    func getFileType() -> AVFileType {
        return UserDefaults.standard.integer(forKey: FILTE_TYPE) == 0 ? .mp4 : .mov
    }
}

    
extension BCMExporter : BCMAssetWriterDelegate{
    
    func getAudioSample() -> CMSampleBuffer? {
        audiotrackReaderOutput?.copyNextSampleBuffer()
    }
    
    func getVideoSample() -> BCMVideoFrame? {
        let progress = composition.getVideoProgress()
        if progress > 1 {
            blendFilter = nil
            transformFilter = nil
            reader = nil
            audiotrackReaderOutput = nil
            assetWriter?.finishWriting(completion: self.completion)
            self.completion = nil
            return nil
        }
//        print("Export slide P: \(source.getSingleSlideProgress()) total P : \(source.getProgress()) ")

        delegate?.updateProgress(value: progress)
                
        presentTime = CMTimeAdd(presentTime, frameTime)


         return autoreleasepool {
            if let mtiImage = composition.draw() {
                composition.increaseFrameCount()

                blendFilter.intensity = 0
                
                transformFilter.transform = CATransform3DMakeTranslation(mtiImage.size.width / 2, mtiImage.size.height / 2 + (CGFloat(height) - mtiImage.size.height) / 2, 0)
                
                if let output = FilterGraph.makeImage(builder: {[weak self] output in
                    guard let self else {
                        return
                    }
                    mtiImage => self.transformFilter => self.blendFilter.inputPorts.inputBackgroundImage
                    self.blendFilter => output
                }){

                    return BCMVideoFrame(frame: output, presentTime: presentTime)
                    
                }
                
            }
             return nil

        }
        

    }
    
    
}


