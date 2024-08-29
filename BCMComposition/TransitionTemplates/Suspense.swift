//
//  Suspense.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 10/7/23.
//

import UIKit
import MetalPetal

class Suspense: BCMTransitionTemplate {
    private let swipeFromMiddle = SwipeFromMiddleTransition()

    override func draw() -> MTIImage? {
        _ = super.draw()
        return swipeFromMiddle.outputImage
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = sin(time * Float.pi * 0.5)

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
    }
}
