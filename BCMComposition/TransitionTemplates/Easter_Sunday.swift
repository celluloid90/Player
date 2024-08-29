//
//  Easter_Sunday.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class Easter_Sunday: BCMTransitionTemplate {

    let swipeFromMiddle = SwipeFromMiddleTransition()
    let overlayFilter = OverlayFilter()
    
    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "easter_SUNDAY"))
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => swipeFromMiddle.inputPorts.inputImage
            source.forgroundImage => swipeFromMiddle.inputPorts.destImage
            
            swipeFromMiddle => overlayFilter => output
        }
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = smoothStep(0, 0.5, time)
        
        swipeFromMiddle.direction = 1
        swipeFromMiddle.progress = time
    }
    
}
