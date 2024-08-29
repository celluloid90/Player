//
//  MothersDay.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class MothersDay: BCMTransitionTemplate {

    let centerBoxTransition = CenterBoxTransition()
    
    let overlayFilter = OverlayFilter()
    
    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "mothers_day"))
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => centerBoxTransition.inputPorts.inputImage
            source.forgroundImage => centerBoxTransition.inputPorts.destImage
            centerBoxTransition => overlayFilter => output
        }
        
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
