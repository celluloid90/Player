//
//  Peace.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 10/7/23.
//

import UIKit
import MetalPetal

class Peace: BCMTransitionTemplate {
    let transformFilter = MTDirectionalTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return transformFilter.outputImage
        
    }
    
    override func updateParams() {
        
        transformFilter.direction = MTIVector(x: -1, y: 0)
        transformFilter.inputImage = source.backgroundImage
        transformFilter.destImage = source.forgroundImage
        
        var time = source.currentProgress
        time = smoothStep(0, 0.5, time)
        transformFilter.progress = sin(time * Float.pi * 0.5)
        

    }
}
