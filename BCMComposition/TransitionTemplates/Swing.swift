//
//  Swing.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 29/3/23.
//

import UIKit
import MetalPetal

class Swing: BCMTransitionTemplate {

    let waterDrop = MTWaterDropTransition()
    let blurFilterBG = MTIMPSBoxBlurFilter()
    let blurFilterFG = MTIMPSBoxBlurFilter()

    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => blurFilterBG => waterDrop.inputPorts.inputImage

            source.forgroundImage  => blurFilterFG => waterDrop.inputPorts.destImage
            
            waterDrop => output
        }
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        let progress = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        waterDrop.progress = progress
        waterDrop.speed = 25
        
        var scale = smoothStep(0, 0.4, time)
        
        blurFilterFG.size = simd_int2(Int32((1 - scale) * 50), Int32((1 - scale) * 50))
        
        blurFilterBG.size = simd_int2(Int32(scale * 50), Int32(scale * 50))
    }
    
}
