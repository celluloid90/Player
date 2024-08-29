//
//  Flash.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 4/6/23.
//

import UIKit
import MetalPetal

class Flash: BCMTransitionTemplate {

    var transitionFilter:MTICoreImageUnaryFilter?
    
    override func setup() {
        var effect = BCMCIEffect()
        effect.filterName = "CIFlashTransition"
        effect.inputCenter = CIVector(x: 0, y: 0)
        effect.inputTime = 1
        
        transitionFilter = MTICoreImageUnaryFilter(effect: effect)
        

    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        transitionFilter?.inputImage = source.backgroundImage

        var center = CIVector(x: 0, y: 0)
        
        center = CIVector(x: source.backgroundImage.extent.width / 2, y: source.backgroundImage.extent.height / 2)
        
        if let ciimage = try? mtiContext?.makeCIImage(from: source.forgroundImage){
            transitionFilter?.setTargetImage(ciimage)
            transitionFilter?.setCenter(center)

        }

        return transitionFilter?.outputImage?.oriented(.downMirrored)
        
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = smoothStep(0, 0.5, time)
        transitionFilter?.setInputTime(time)
    }
    
}
