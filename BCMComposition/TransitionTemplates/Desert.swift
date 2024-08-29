//
//  Desert.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/3/23.
//

import UIKit
import MetalPetal

class Desert: BCMTransitionTemplate {

    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        blendFilter.inputImage = source.forgroundImage
        blendFilter.inputBackgroundImage = source.backgroundImage
        
        return blendFilter.outputImage?.oriented(.downMirrored)
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        let progress = smoothStep(0, 0.5, time)
        let threshold:Float = 0.03
        blendFilter.intensity = progress == 1 ? progress : Float.random(in: (progress - threshold)...(progress + threshold))

    }
}
