//
//  OvalShape.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 15/5/23.
//

import UIKit
import MetalPetal

class OvalShape: BCMTransitionTemplate {
    
    var ovalShapeTransition : MTICoreImageUnaryFilter!
    
    override func setup() {

        var effect = BCMCIEffect()
        effect.filterName = "CIModTransition"
        effect.inputAngle = -0.174533
        effect.inputCenter = CIVector(x: 0, y: 0)
        
        ovalShapeTransition = MTICoreImageUnaryFilter(effect: effect)
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        ovalShapeTransition.inputImage = source.backgroundImage
        
        if let ciimage = try? mtiContext?.makeCIImage(from: source.forgroundImage){
            ovalShapeTransition.setTargetImage(ciimage)
        }
        return ovalShapeTransition.outputImage?.oriented(.downMirrored)
    }
    
    override func updateParams() {
        var time = source.currentProgress
        
        time = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        
        ovalShapeTransition.setInputTime(time)
    }
}
