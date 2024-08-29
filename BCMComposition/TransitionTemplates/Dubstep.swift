//
//  Dubstep.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 16/7/23.
//

import UIKit
import MetalPetal

class Dubstep: BCMTransitionTemplate {

    let swipeFromMiddle = SwipeFromMiddleTransition()
    
    let wipeUp = MTWipeDownTransition()
    let wipeRight = MTWipeRightTransition()

    var transition :BCMTransition!
    
    override func setup() {
        
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        transition.inputImage = source.backgroundImage
        transition.destImage = source.forgroundImage
        
        return transition.outputImage
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        switch source.currentAssetIndex % 4{
        case 0:
            transition = wipeUp
            break
        case 1:
            swipeFromMiddle.direction = 0
            transition = swipeFromMiddle
            break
        case 2:
            transition = wipeRight
            break
        case 3:
            swipeFromMiddle.direction = 1
            transition = swipeFromMiddle
            break
        default:
            break
        }
        
        transition.progress = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        
    }
    
}
