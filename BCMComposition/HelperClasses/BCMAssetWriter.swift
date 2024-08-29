//
//  AssetWriter.swift
//  ImageTransition
//
//  Created by BCL Device7 on 19/7/22.
//

import AVFoundation
import CoreMedia
import CoreImage
import MetalPetal

enum BCMWriterFrameType{
    case MTIImage,CIImage,CGImage
}

class BCMVideoFrame{
    var frame: MTIImage
    var presentTime:CMTime
    
    init(frame: MTIImage, presentTime: CMTime) {
        self.frame = frame
        self.presentTime = presentTime
    }
}

protocol BCMAssetWriterDelegate:NSObjectProtocol {
    func getAudioSample() -> CMSampleBuffer?
    func getVideoSample() -> BCMVideoFrame?
}

class BCMAssetWriter{
    
    private var writer:AVAssetWriter!
    private var videoInput:AVAssetWriterInput!
    private var audioInput:AVAssetWriterInput?

    private var pixelBufferAdaptor:AVAssetWriterInputPixelBufferAdaptor!

    private var pixelBufferPool:CVPixelBufferPool!

    private var outputSize:CGSize!
    private lazy var context = CIContext()
    
    weak var delegate: BCMAssetWriterDelegate?
    var mtiContext : MTIContext?
    private lazy var writerQueue = DispatchQueue(label: "com.slideshow.assetWriterQueue",qos: .default)
    
    init(outputSize:CGSize,outputUrl:URL,withAudio: Bool) {
        self.outputSize = outputSize
        setup(outputUrl: outputUrl,withAudio: withAudio)
    }
    
    private func setup(outputUrl: URL,withAudio: Bool){
        
//        guard let documentDirectory = getDocumentUrl() else { return }
//
//        let fileName = "slideShow" + (fileType == .mov ? ".mov" : ".mp4")
//        let path = documentDirectory.appendingPathComponent(fileName).path
//        let tempURL = URL(fileURLWithPath: path)
        
        var fileType:AVFileType = .mp4
        if outputUrl.pathExtension.lowercased() == "mov"{
            fileType = .mov
        }
        
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            try? FileManager.default.removeItem(at: outputUrl)
        }
        
        writer = try? AVAssetWriter(outputURL: outputUrl, fileType: fileType)
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: outputSize.width,
            AVVideoHeightKey: outputSize.height
        ]

        //video input
        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput.expectsMediaDataInRealTime = false
        let attributes = sourceBufferAttributes(outputSize: outputSize)
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput,
                                                                  sourcePixelBufferAttributes: attributes)
        if writer?.canAdd(videoInput) ?? false{
            writer?.add(videoInput)
        }
        
        if withAudio{
            var channelLayout = AudioChannelLayout()

            memset(&channelLayout, 0, MemoryLayout<AudioChannelLayout>.size)

            channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo
            //audio input
            let audioSettings: [String : Any] = [
                AVNumberOfChannelsKey: 2,
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100,
                AVEncoderBitRateKey: 128000,
                AVChannelLayoutKey: Data(bytes: &channelLayout, count: MemoryLayout<AudioChannelLayout>.size)

            ]
            
            audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings )
            audioInput?.expectsMediaDataInRealTime = false
            
            
            if writer?.canAdd(audioInput!) ?? false{
                writer?.add(audioInput!)
            }
        }

    }
    
    func startSession() -> Void {
        guard let success = writer?.startWriting(), success == true else {
            fatalError("Can not start writing")
        }
        self.pixelBufferPool = pixelBufferAdaptor?.pixelBufferPool

        guard self.pixelBufferPool != nil else {
            fatalError("AVAssetWriterInputPixelBufferAdaptor pixelBufferPool empty")
        }
        
        writer?.startSession(atSourceTime: .zero)
    }
    
    func startAddingAudioSample() {
        audioInput?.requestMediaDataWhenReady(on: writerQueue) { [weak self] in
            guard let self else {return}

            while self.audioInput?.isReadyForMoreMediaData ?? false{
                if let sample = self.delegate?.getAudioSample(){
                    self.audioInput?.append(sample)
                    CMSampleBufferInvalidate(sample)
                    print("~", separator: " ", terminator: " ")
                }else{
                    self.audioInput?.markAsFinished()
                }
            }
        }
    }
    
    func startAddingVideoSample() {
        videoInput.requestMediaDataWhenReady(on: writerQueue) { [weak self] in
            guard let self else {return}
            while self.videoInput.isReadyForMoreMediaData{
                
                if let videoFrame = self.delegate?.getVideoSample(){
                    self.addBufferToPool(frame: videoFrame.frame, presentTime: videoFrame.presentTime)
                }
            }
        }
    }
    
    func cancel(completion:@escaping (Result<URL?, Error>?) -> Void) -> Void {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: {
            self.mtiContext?.reclaimResources()
        })
        
        videoInput?.markAsFinished()
        audioInput?.markAsFinished()
        
        if writer.status == .writing{
            writer.cancelWriting()
            completion(.success(self.writer.outputURL))
            return
        }
    }
    
    func addAudioBuffer(buffer: CMSampleBuffer) -> Void {
        while !(self.audioInput?.isReadyForMoreMediaData ?? true)  {
            Thread.sleep(forTimeInterval: 0.01)
        }
        if audioInput?.append(buffer) ?? false{
            print("~", separator: " ", terminator: " ")
        }
        CMSampleBufferInvalidate(buffer)
    }
    
    func addBufferToPool(frame:CGImage,presentTime:CMTime) -> Void {
        guard let adapter = pixelBufferAdaptor else {
            return
        }
        
        while !self.videoInput.isReadyForMoreMediaData {
            Thread.sleep(forTimeInterval: 0.01)
        }

    }
    
    func addBufferToPool(frame:MTIImage,presentTime:CMTime) -> Void {
        guard let pool = self.pixelBufferPool,let adapter = pixelBufferAdaptor else {
            return
        }
        
        while !self.videoInput.isReadyForMoreMediaData {
            Thread.sleep(forTimeInterval: 0.01)
        }
        
        
        autoreleasepool {
            var pixelBuffer: CVPixelBuffer?
            CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer)
            if let buffer = pixelBuffer{
                try? mtiContext?.render(frame, to: buffer)
                adapter.append(buffer, withPresentationTime: presentTime)
                print(".", separator: " ", terminator: " ")
            }
        }
        
    }
    
    func addBufferToPool(frame:CIImage,presentTime:CMTime) -> Void {
        guard let pool = self.pixelBufferPool,let adapter = pixelBufferAdaptor else {
            return
        }
        
        while !self.videoInput.isReadyForMoreMediaData {
            Thread.sleep(forTimeInterval: 0.01)
        }
        autoreleasepool {
            var pixelBuffer: CVPixelBuffer?
            CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer)
            if let buffer = pixelBuffer{
                context.render(frame, to: buffer)
                adapter.append(buffer, withPresentationTime: presentTime)
                print(".", separator: " ", terminator: " ")
                context.clearCaches()
            }
        }
        
    }
    
    
    private func sourceBufferAttributes(outputSize: CGSize) -> [String: Any] {
        let attributes: [String: Any] = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
            (kCVPixelBufferWidthKey as String): outputSize.width,
            (kCVPixelBufferHeightKey as String): outputSize.height
        ]
        return attributes
    }
    
    func setVideoOptimizeForNetwork(value: Bool) -> Void {
        writer.shouldOptimizeForNetworkUse = value
    }
    
    func finishWriting(completion:@escaping (Result<URL?, Error>?) -> Void) -> Void {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1, execute: {
            self.mtiContext?.reclaimResources()
        })
        
        videoInput?.markAsFinished()
        audioInput?.markAsFinished()
                
        writer?.finishWriting { [weak self] in
            guard let self else {return}

            DispatchQueue.main.async {
                if let error = self.writer?.error {
                    print("video written failed \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("video written succesfully")
                    completion(.success(self.writer.outputURL))
                }
            }
        }
    }
    
}

