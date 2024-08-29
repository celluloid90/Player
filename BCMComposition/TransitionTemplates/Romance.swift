//
//  Romance.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit
import MetalPetal

class Romance: BCMTransitionTemplate {

    let centerBoxTransition = CenterBoxTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        centerBoxTransition.inputImage = source.backgroundImage
        centerBoxTransition.destImage = source.forgroundImage
        
        return centerBoxTransition.outputImage
        
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = smoothStep(0, 0.6, time)
        time = sin(time * 3.1416 * 0.5)
        centerBoxTransition.radius = time
        centerBoxTransition.progress = time
        centerBoxTransition.angle = 0
        
    }
    
}
