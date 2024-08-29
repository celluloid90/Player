//
//  SlideVideoDecoder.swift
//  SlideShowMaker
//
//  Created by BCL Device7 on 15/11/22.
//

import Foundation
import AVFoundation
import MetalPetal

enum FrameType {
case new,previous,skipped
}

class BCMVideoFrameDecoder {
    
    private var assetUrl:URL!
    private var reader:AVAssetReader!
    private var trackReaderOutput:AVAssetReaderTrackOutput!
    var composition : AVMutableComposition!
    
    private var compositionTrack : AVMutableCompositionTrack!
    
    private var imageGenerator : AVAssetImageGenerator!
    
    var presentTime:CMTime = .zero
    private var naturalSize : CGSize = .zero
    private var currentTimeRange:CMTimeRange = .zero
    
    public var rangeInSec:(start:Double,end:Double) =  (0,0)
    
    var currentFrame : MTIImage?
    var currentFrameType : FrameType = .new
    private var currentTime : CMTime = .zero
    var frameDuration : CMTime = .zero
    var videoIsEnded = false
    
    var speed: Float = 1 {
        didSet{
            compositionTrack.scaleTimeRange(currentTimeRange, toDuration: CMTime(seconds: currentTimeRange.duration.seconds / Double(speed), preferredTimescale:composition.duration.timescale))

        }
    }
    
    var sliderValueChanging = false {
        didSet{
            if sliderValueChanging == false{
                syncReader()
            }
            print("sliderValueChanging value changed" )
        }
    }
    
    var transitionDuration : Float = 0

    
    func setCurrVideo(url:URL) -> Void {
        print("videoDecode reset new url set")

        rangeInSec = (0,0)
        
        self.assetUrl = url

        
        prepareComposition()
        prepareReader()
        prepareImageGenerator()
    }
    
    func getNaturalSize() -> CGSize {
        return naturalSize
    }
    
    private func prepareComposition (){
        
        let asset = AVAsset(url: assetUrl)
        
        composition = AVMutableComposition()
        
        compositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)

        guard let videoTrack = asset.tracks(withMediaType: .video).first else {return}
        
        naturalSize = videoTrack.naturalSize
        
        
        if rangeInSec.end == 0{
            rangeInSec.end = CMTimeGetSeconds(videoTrack.timeRange.duration)
        }
        
        if rangeInSec.start >= rangeInSec.end {
            rangeInSec.start = 0
        }
        
        let start = CMTime(seconds: rangeInSec.start * Double(speed), preferredTimescale: videoTrack.naturalTimeScale)
        let end = CMTime(seconds: rangeInSec.end, preferredTimescale: videoTrack.naturalTimeScale)
        
        currentTimeRange = CMTimeRange(start: start, end: end)
        
        do {
            try compositionTrack?.insertTimeRange(currentTimeRange, of: videoTrack, at: .zero)
        } catch  {
            print("can't prepare video composition")
        }
        
        compositionTrack.scaleTimeRange(currentTimeRange, toDuration: CMTime(seconds: currentTimeRange.duration.seconds / Double(speed), preferredTimescale:composition.duration.timescale))
        
        frameDuration = compositionTrack.minFrameDuration

        
        transitionDuration = transitionDuration == 0 ? Float(composition.duration.seconds) : transitionDuration
        
        
    }
    
    func prepareImageGenerator() -> Void {
        
        if compositionTrack == nil {return}

        imageGenerator = AVAssetImageGenerator(asset: composition)
        imageGenerator.requestedTimeToleranceAfter = .zero
        imageGenerator.requestedTimeToleranceBefore = .zero
        
    }
    
    private func prepareReader() -> Void {
        if reader?.status == .reading {
            reader?.cancelReading()
        }
        
        guard compositionTrack != nil else {
            print("can't load overlay video")
            return
        }
        
        do {
            reader = try AVAssetReader(asset: composition)
        } catch  {
            print(error.localizedDescription)
        }
        
        let outputVideoSettings = [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)]

        //outputVideoSettings[String(kCVPixelBufferWidthKey)] = 1080
        //outputVideoSettings[String(kCVPixelBufferHeightKey)] = 1080
        
        // read video frames as BGRA
        trackReaderOutput = AVAssetReaderTrackOutput(track: compositionTrack, outputSettings:outputVideoSettings)
        trackReaderOutput.supportsRandomAccess = true
        reader.add(trackReaderOutput)
        reader.startReading()
        
        presentTime = .zero
        videoIsEnded = false
    }
    
    func getFrame(time:Float) -> MTIImage? {
        print("videoDecode progress \(time)")
        guard trackReaderOutput != nil else {
            return nil
        }
        
        if sliderValueChanging {
            return generateFrame(time: time)
        }
        
        var cmTime = CMTimeMakeWithSeconds(Double(transitionDuration) * Double(time) / Double(speed), preferredTimescale: presentTime.timescale)
        
        cmTime = CMTimeAdd(cmTime, CMTime(value: Int64(Float(frameDuration.value)), timescale: frameDuration.timescale))

        
        if cmTime.seconds < presentTime.seconds{
            //print("videoDecode returning previous reqTime \(cmTime.seconds) pTime \(presentTime.seconds) time \(time)")
            currentFrameType = .previous
            return currentFrame
        }
        

        if var sampleBuffer = trackReaderOutput.copyNextSampleBuffer(){

            var tempPresentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            tempPresentTime = CMTime(seconds: tempPresentTime.seconds + rangeInSec.start, preferredTimescale: tempPresentTime.timescale == 1 ? 600 : tempPresentTime.timescale)
            currentFrameType = .new
            if (cmTime.seconds - tempPresentTime.seconds) > (2 * frameDuration.seconds) {

                while let tempBuffer = trackReaderOutput.copyNextSampleBuffer() {
                    currentFrameType = .skipped
                   // print("videoDecode skipping ptime \(tempPresentTime.seconds) time \(time)")
                    var tempPTime = CMSampleBufferGetPresentationTimeStamp(tempBuffer)
                    tempPTime = CMTime(seconds: tempPTime.seconds + rangeInSec.start, preferredTimescale: tempPTime.timescale == 1 ? 600 : tempPTime.timescale)
                    
                    
                    if (cmTime.seconds - tempPTime.seconds) <= frameDuration.seconds {
                        
                        sampleBuffer = tempBuffer
                        tempPresentTime = tempPTime
                        
                        break
                    }
                    
                }
            }
            

            presentTime = tempPresentTime
            currentTime = presentTime
            
            //print("videoDecode fetching new frame ptime \(presentTime.seconds) time \(time)")
            if Float(presentTime.seconds) == transitionDuration{
                videoIsEnded = true
            }
            
            autoreleasepool {
                if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                    currentFrame = MTIImage(cvPixelBuffer: pixelBuffer, alphaType: .nonPremultiplied)
                }
                CMSampleBufferInvalidate(sampleBuffer)
            }
            


            return currentFrame

        }else{
            videoIsEnded = true
            return currentFrame

            /*
            print("videoDecode video reset frame out")

            presentTime = .zero
            let range =  NSValue(timeRange: CMTimeRange(start: .zero, duration: composition.duration))
            if reader.status != .failed && reader.status != .cancelled {
                trackReaderOutput.reset(forReadingTimeRanges: [range])
                //return getFrame(time: time)
            }else{
                prepareReader()
                //return getFrame(time: time)

            }
            */
            
        }
                
    }
    
    func syncReader() -> Void {
        
        rangeInSec.start = currentTime.seconds
        prepareComposition()
        prepareReader()
        presentTime = currentTime
    }
    
    private func generateFrame(time: Float) -> MTIImage? {
        imageGenerator.cancelAllCGImageGeneration()
        let duration = transitionDuration
        
        let cmTime = CMTimeMakeWithSeconds(Double(duration) * Double(time) / Double(speed), preferredTimescale: composition.duration.timescale)
        var actualTime : CMTime = .zero
        print("genrating frame by image generator")
        if let myImage = try? imageGenerator.copyCGImage(at: cmTime, actualTime: &actualTime){
            currentTime = actualTime
            currentFrame = MTIImage(cgImage: myImage, options: [.SRGB:false]).unpremultiplyingAlpha()
            return currentFrame
        }
        
        return nil
    }
    
    func resetTrackReader() -> Void {
        if CMTimeCompare(presentTime, .zero) == 0 {
            return
        }
        
        rangeInSec.start = .zero
        
        prepareComposition()
        prepareReader()
        prepareImageGenerator()
        print("videoDecode reset")
    }
    
    func clear() -> Void {
        
        if reader?.status == .reading {
            reader?.cancelReading()
        }
        
        reader = nil
        composition = nil
        compositionTrack = nil
    
    }
    
    
}
