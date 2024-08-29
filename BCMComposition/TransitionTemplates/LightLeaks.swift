//
//  LightLeaks.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/5/23.
//

import UIKit
import MetalPetal

class LightLeaks: BCMTransitionTemplate {

    private let swipeFromMiddle = SwipeFromMiddleTransition()
    var videoOverlayFilter : VideoOverlayFilter!

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
        super.setup()
        videoOverlayFilter = VideoOverlayFilter(video: BCMVideoItem(name: "Chaplin"))
        videoOverlayFilter.totalSlideShowTime = source.duration

    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.backgroundImage
        swipeFromMiddle.destImage = source.forgroundImage
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => swipeFromMiddle.inputPorts.destImage
            source.forgroundImage  => swipeFromMiddle.inputPorts.inputImage
            
            swipeFromMiddle => videoOverlayFilter.inputPorts.inputImage
            
            videoOverlayFilter => output
        }
        return output
    }
    
    override func updateParams() {
        
        let time = source.currentProgress
        videoOverlayFilter.progress = source.getVideoProgress()

        let tTime  = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        swipeFromMiddle.progress = 1 - tTime
        
        videoOverlayFilter.overlayOpacity = 0.4
        
        swipeFromMiddle.direction = 0

        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
        }
        
    }
    
}
