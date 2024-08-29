//
//  NightOut.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/3/23.
//

import UIKit
import MetalPetal

class NightOut: BCMTransitionTemplate {
    
    let halfWipeTransition = HalfDirectionalWipeTransition()
    private let swipeFromMiddle = SwipeFromMiddleTransition()

    private var transition = BCMTransition()

    override func draw() -> MTIImage? {
        _ = super.draw()
        
        transition.inputImage = source.backgroundImage
        transition.destImage = source.forgroundImage
        
        return transition.outputImage
        
    }
    
    override func updateParams() {
        
        let time = source.currentProgress
        
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
