//
//  SoftSpot.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class SoftSpot: BCMTransitionTemplate {
    private let swipeFromMiddle = SwipeFromMiddleTransition()
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
        
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "34912279"))
        videoOverlayFilter.totalSlideShowTime = source.duration

        
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        return FilterGraph.makeImage { output in
            swipeFromMiddle => videoOverlayFilter => output
        }
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = sin(time * Float.pi * 0.5)
        videoOverlayFilter.progress = time
        if source.currentAssetIndex % 2 == 0{
            time = 1 - smoothStep(0, 0.5, time)
            swipeFromMiddle.inputImage = source.forgroundImage
            swipeFromMiddle.destImage = source.backgroundImage
        }else{
            time = smoothStep(0, 0.5, time)
            swipeFromMiddle.inputImage = source.backgroundImage
            swipeFromMiddle.destImage = source.forgroundImage
        }
        
        swipeFromMiddle.direction = 0
        swipeFromMiddle.progress = time
        
        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
            videoOverlayFilter.resetTrack()
            
        }
    }
}
