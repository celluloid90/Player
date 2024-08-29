//
//  Twinkling.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 11/6/23.
//

import UIKit
import MetalPetal

class Twinkling: BCMTransitionTemplate {
    private let swipeFromMiddle = SwipeFromMiddleTransition()
    private let videoOverlayFilter = VideoOverlayFilter()
    
    override var renderSize: CGSize{
        didSet{
            videoOverlayFilter.frameSize = renderSize
        }
    }
    
    override var sliderValueChanging: Bool {
        didSet{
            videoOverlayFilter.sliderValueChanging(value: sliderValueChanging)
        }
    }
    
    override func setup() {
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "12566960"))
        videoOverlayFilter.totalSlideShowTime = source.duration
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.forgroundImage
        swipeFromMiddle.destImage = source.backgroundImage
        
        return FilterGraph.makeImage { output in
            swipeFromMiddle => videoOverlayFilter => output
        }
        
    }
    
    override func updateParams() {
        var time = source.currentProgress
        videoOverlayFilter.progress = source.getVideoProgress()
        
        time = sin(smoothStep(0, 0.3, time) * Float.pi * 0.5)
        
        swipeFromMiddle.direction = 1
        swipeFromMiddle.progress = 1 - time
    }
    
    
}
