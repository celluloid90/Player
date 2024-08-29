//
//  GoodTimes.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 10/7/23.
//

import UIKit
import MetalPetal

class GoodTimes: BCMTransitionTemplate {
    private let swipeFromMiddle = SwipeFromMiddleTransition()

    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.forgroundImage
        swipeFromMiddle.destImage = source.backgroundImage
        
        return swipeFromMiddle.outputImage
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = 1 - smoothStep(0, 0.5, sin(time * Float.pi * 0.5))
        swipeFromMiddle.direction = 1
        swipeFromMiddle.progress = time
    }
    
}
