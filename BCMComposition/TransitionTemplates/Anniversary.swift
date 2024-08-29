//
//  Anniversary.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 16/7/23.
//

import UIKit
import MetalPetal

class Anniversary: BCMTransitionTemplate {
    
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let overlayFilter = OverlayFilter()
    
    override var renderSize: CGSize{
        didSet{
            overlayFilter.frameSize = renderSize
        }
    }
    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "anniversary"))
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => blendFilter.inputPorts.inputImage
            
            blendFilter => overlayFilter => output
        }
        
        return output
    }
    
    override func updateParams() {
        let time = source.currentProgress
        overlayFilter.chageInputOrientation = true
        blendFilter.intensity = smoothStep(0, 0.2, time)
                
    }
    
}
