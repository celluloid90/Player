//
//  PlayTime.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 12/7/23.
//

import UIKit
import MetalPetal

class PlayTime: BCMTransitionTemplate {
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => blendFilter.inputPorts.inputImage
            
            blendFilter => output
        }
        return output?.oriented(.downMirrored)
    }
    
    override func updateParams() {
        let time = source.currentProgress

        blendFilter.intensity = smoothStep(0, 0.2, time)
                
    }
}
