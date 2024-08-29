//
//  Kamuro.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 11/6/23.
//

import UIKit
import MetalPetal

class Kamuro: BCMTransitionTemplate {
    let videoOverlayFilter = VideoOverlayFilter()
    let halfWipeTransition = HalfDirectionalWipeTransition()
    private let swipeFromMiddle = SwipeFromMiddleTransition()

    private var transition = BCMTransition()

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
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "2425055"))
        videoOverlayFilter.totalSlideShowTime = source.duration

        
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        transition.inputImage = source.backgroundImage
        transition.destImage = source.forgroundImage
        
        return FilterGraph.makeImage { output in
            transition => videoOverlayFilter => output
        }
        
    }
    
    override func updateParams() {
        
        let time = source.currentProgress
        videoOverlayFilter.progress = source.getVideoProgress()
        
        let progress = sin(smoothStep(0, 0.5, time) * 3.1416 * 0.5)
        
        switch source.currentAssetIndex % 3 {
        case 0:
            transition = halfWipeTransition
            break
        case 1:
            swipeFromMiddle.direction = 0
            transition = swipeFromMiddle
            break
        case 2:
            swipeFromMiddle.direction = 1
            transition = swipeFromMiddle
            break
        default:
            break
        }
        
        
        transition.progress = progress
        
    }
}
