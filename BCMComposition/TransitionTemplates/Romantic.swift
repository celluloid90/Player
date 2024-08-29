//
//  Romantic.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class Romantic: BCMTransitionTemplate {
    let overlayFilter = OverlayFilter()
    let borderSwipe = BorderSwipeTransition()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "romantic"))
        overlayFilter.chageInputOrientation = true
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        overlayFilter.inputImage = FilterGraph.makeImage { output in
            
            source.backgroundImage  => blendFilter.inputPorts.inputBackgroundImage
            
            source.forgroundImage => blendFilter.inputPorts.inputImage
            
            blendFilter => borderSwipe.inputPorts.destImage
            
            source.backgroundImage => borderSwipe.inputPorts.inputImage

            borderSwipe => output
            
        }?.oriented(.downMirrored)
        
        return overlayFilter.outputImage
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
                
        let progress = Float(sin(smoothStep(0, 0.7, time) * Float.pi * 0.5))
        blendFilter.intensity = progress
        borderSwipe.progress = progress
        borderSwipe.length = 0
        
    }

}
