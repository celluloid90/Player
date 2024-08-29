//
//  Glitter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 4/6/23.
//

import UIKit
import MetalPetal

class Glitter: BCMTransitionTemplate {

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
        
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "br30"))
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
            
        }
    }
    
}
