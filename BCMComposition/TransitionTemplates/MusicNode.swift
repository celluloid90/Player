//
//  MusicNode.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class MusicNode: BCMTransitionTemplate {
    let videoOverlayFilter = VideoOverlayFilter()
    
    override var sliderValueChanging: Bool {
        didSet{
            videoOverlayFilter.sliderValueChanging(value: sliderValueChanging)
        }
    }
    override var renderSize: CGSize{
        didSet{
            videoOverlayFilter.frameSize = renderSize
        }
    }
    
    override func setup() {
        super.setup()
        
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "15a"))
        videoOverlayFilter.totalSlideShowTime = source.duration

        
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        videoOverlayFilter.inputImage =  source.forgroundImage
        return videoOverlayFilter.outputImage?.oriented(.downMirrored)
    }
    
    override func updateParams() {
        let time = source.currentProgress
        videoOverlayFilter.progress = source.getVideoProgress()

        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
            videoOverlayFilter.resetTrack()
            
        }
    }
}
