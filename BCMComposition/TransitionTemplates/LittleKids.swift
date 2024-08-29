//
//  LittileKids.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 27/3/23.
//

import UIKit
import MetalPetal

class LittleKids: BCMTransitionTemplate {

    let transformFilter = MTDirectionalTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return transformFilter.outputImage
        
    }
    
    override func updateParams() {
        
        if source.currentAssetIndex % 2 == 0{
            transformFilter.direction = MTIVector(x: 0, y: 1)
            transformFilter.inputImage = source.backgroundImage
            transformFilter.destImage = source.forgroundImage
        }else{
            transformFilter.direction = MTIVector(x: 0, y: -1)
            transformFilter.inputImage = source.backgroundImage
            transformFilter.destImage = source.forgroundImage
            
        }
        
        var time = source.currentProgress
        time = smoothStep(0, 0.8, time)
        transformFilter.progress = sin(time * 3.1416 * 0.5)
        

    }
    
}
