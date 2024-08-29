//
//  Bokeh.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class Bokeh: BCMTransitionTemplate {

    let swipeFromMiddle = SwipeFromMiddleTransition()
    let upWipe = MTWipeUpTransition()
    let downWipe = MTWipeDownTransition()
    var transition : BCMTransition!
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
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "25206092"))
        videoOverlayFilter.totalSlideShowTime = source.duration
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        return FilterGraph.makeImage { output in
            transition => videoOverlayFilter => output
        }
    }
    
    override func updateParams() {
        var time = source.currentProgress
        videoOverlayFilter.progress = time

        time = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        
        switch source.currentAssetIndex % 4 {
        case 0:
            transition = downWipe
            transition.inputImage = source.backgroundImage
            transition.destImage = source.forgroundImage
            break
        case 1:
            time = 1 - time
            swipeFromMiddle.direction = 0
            transition = swipeFromMiddle
            transition.inputImage = source.forgroundImage
            transition.destImage = source.backgroundImage
            break
        case 2:
            transition = upWipe
            transition.inputImage = source.backgroundImage
            transition.destImage = source.forgroundImage
            break
        case 3:
            swipeFromMiddle.direction = 1
            transition = swipeFromMiddle
            transition.inputImage = source.backgroundImage
            transition.destImage = source.forgroundImage
            break
        default:
            break
        }
        
        transition.progress = time
        
        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
            videoOverlayFilter.resetTrack()
            
        }
    }
    
}
