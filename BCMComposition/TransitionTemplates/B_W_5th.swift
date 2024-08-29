//
//  NinetysMovie.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/5/23.
//

import UIKit
import MetalPetal

class B_W_5th: BCMTransitionTemplate {

    private let swipeFromMiddle = SwipeFromMiddleTransition()
    let transformFilterFG = MTITransformFilter()
    let transformFilterBG = MTITransformFilter()
    let saturationFilter = MTISaturationFilter()
    
    
    override func setup() {
        super.setup()
        
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.backgroundImage
        swipeFromMiddle.destImage = source.forgroundImage
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => transformFilterBG => saturationFilter => swipeFromMiddle.inputPorts.inputImage
            source.forgroundImage => transformFilterFG => saturationFilter => swipeFromMiddle.inputPorts.destImage
            
            swipeFromMiddle => output
            
            
        }
        return output
    }
    
    override func updateParams() {
        
        
        let time = source.currentProgress
        
        swipeFromMiddle.progress = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)

        var zTime = sin(smoothStep(0.5, 1, time) * Float.pi * 0.5)
        
        transformFilterFG.transform = CATransform3DMakeScale(CGFloat(1 + zTime * 0.025), CGFloat(1 + zTime * 0.025), 1)
        
        zTime = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)

        transformFilterBG.transform = CATransform3DMakeScale(CGFloat(1.025 + zTime * 0.025), CGFloat(1.025 + zTime * 0.025), 1)

        swipeFromMiddle.direction = 0
        
        saturationFilter.saturation = 0
        
    }
}
