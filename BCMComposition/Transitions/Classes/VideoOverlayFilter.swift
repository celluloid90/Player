//
//  VideoOverlayFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/5/23.
//

import UIKit
import MetalPetal

class VideoOverlayFilter: MTIUnaryFilter {
    
    var inputImage: MTIImage?
    var frameSize :CGSize = .zero
    private var videoDecoder = BCMVideoFrameDecoder()
    private let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    var outputPixelFormat: MTLPixelFormat = .invalid

    var totalSlideShowTime:Float = 0
    private var prevProgress:Float = 0
    
    public var progress: Float = 0 {
        didSet{
            
            if progress == 0 && videoDecoder.presentTime.seconds != 0{
                videoDecoder.resetTrackReader()
            }
            
            let high = videoDecoder.transitionDuration * videoDecoder.speed / totalSlideShowTime

            progress = progress.truncatingRemainder(dividingBy: high)

            if abs(progress - prevProgress) > 0.9{
                videoDecoder.resetTrackReader()
            }
            
            progress = smoothStep(0, high, progress)
            //print("overlay progress \(progress) slideSHow progress \(temp)")
            
        }
    }
    public var overlayOpacity: Float = 0.3
    
    
    init(video:BCMVideoItem) {
        videoDecoder.setCurrVideo(url: video.url)
    }
    
    init() {
        
    }
    
    func setCurrVideo(video: BCMVideoItem) -> Void {
        videoDecoder.setCurrVideo(url: video.url)
    }
    
    func setVideoSpeed(value: Float) -> Void {
        videoDecoder.speed = value
    }
    
    
    public var outputImage: MTIImage? {
        guard let inputImage else {
            return inputImage
        }
        
        let vImage = videoDecoder.getFrame(time: progress)?.centerCropped(frameSize)

        if vImage == nil {
            return inputImage
        }
        
        blendFilter.inputBackgroundImage = inputImage
        blendFilter.inputImage = vImage?.oriented(.downMirrored)
        blendFilter.intensity = overlayOpacity
        
        prevProgress = progress
        
        return blendFilter.outputImage
    }
    
    func resetTrack() -> Void {
        videoDecoder.resetTrackReader()
    }
    
    func sliderValueChanging(value: Bool) -> Void {
        videoDecoder.sliderValueChanging = value
    }
}
