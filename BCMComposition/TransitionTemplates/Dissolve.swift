//
//  Dissolve.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 10/7/23.
//

import UIKit
import MetalPetal

class Dissolve: BCMTransitionTemplate {
    var dissolveTransition : MTICoreImageUnaryFilter!

    override func setup() {
        var effect = BCMCIEffect()
        effect.filterName = "CIAccordionFoldTransition"
        effect.inputBottomHeight = 100
        effect.inputFoldShadowAmount = 1
        effect.inputNumberOfFolds = 6
        
        dissolveTransition = MTICoreImageUnaryFilter(effect: effect)
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        dissolveTransition.inputImage = source.backgroundImage
        
        if let ciimage = try? mtiContext?.makeCIImage(from: source.forgroundImage){
            dissolveTransition.setTargetImage(ciimage)
        }
        return dissolveTransition.outputImage?.oriented(.downMirrored)
    }
    
    override func updateParams() {
        var time = source.currentProgress
        
        time = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)

        dissolveTransition.setInputTime(time)
    }
    
}
