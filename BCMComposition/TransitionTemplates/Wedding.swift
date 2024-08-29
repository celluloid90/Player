//
//  Wedding.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit
import MetalPetal

class Wedding: BCMTransitionTemplate {

    private let swipeFromMiddle = SwipeFromMiddleTransition()
    private let transformFilterBG = MTITransformFilter()
    private let transformFilterFG = MTITransformFilter()

    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.backgroundImage
        swipeFromMiddle.destImage = source.forgroundImage
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => transformFilterBG => swipeFromMiddle.inputPorts.inputImage
            source.forgroundImage => transformFilterFG => swipeFromMiddle.inputPorts.destImage
            
            swipeFromMiddle => output
        }
        
    }
    
    override func updateParams() {
        let time = super.source.currentProgress
        
        swipeFromMiddle.direction = source.currentAssetIndex % 2
        
        swipeFromMiddle.progress = sin(smoothStep(0, 0.5, time) * 3.1416 * 0.5)
        let scale = 1 + sin(time * 3.1416 * 0.5) * 0.1
        transformFilterFG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
        
        transformFilterBG.transform = CATransform3DMakeScale(1.1, 1.1, 1)

    }
    
    
}
