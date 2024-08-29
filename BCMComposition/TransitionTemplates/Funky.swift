//
//  Funky.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

import UIKit
import MetalPetal

class Funky: BCMTransitionTemplate {

    let transition = HeartShapeTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        return transition.outputImage
    }
    
    override func updateParams() -> Void {
        let time = source.currentProgress
        
        transition.radius = smoothStep(0, 0.5, time)
        
        if source.currentAssetIndex % 2 == 0{
            transition.inputImage = source.backgroundImage
            transition.destImage = source.forgroundImage
        }else{
            transition.inputImage = source.forgroundImage
            transition.destImage = source.backgroundImage

            transition.radius = 1 - transition.radius
        }
        
    }
    
}
