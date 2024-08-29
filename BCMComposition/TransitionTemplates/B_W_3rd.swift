//
//  B_W_3rd.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/5/23.
//

import UIKit
import MetalPetal

class B_W_3rd: BCMTransitionTemplate {

    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let saturationFilter = MTISaturationFilter()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => saturationFilter => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage  => saturationFilter => blendFilter.inputPorts.inputImage
            
            blendFilter => output
        }
        return output?.oriented(.downMirrored)
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        blendFilter.intensity = smoothStep(0, 0.3, time)
        
        saturationFilter.saturation = 0
    }
    
    
}
