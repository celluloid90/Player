//
//  IndependenceDay.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class IndependenceDay: BCMTransitionTemplate {
    
    let halfWipeTransition = HalfDirectionalWipeTransition()
    let overlayFilter = OverlayFilter()
    
    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "independence-day"))
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => halfWipeTransition.inputPorts.inputImage
            source.forgroundImage => halfWipeTransition.inputPorts.destImage
            
            halfWipeTransition => overlayFilter => output
        }
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        halfWipeTransition.direction = source.currentAssetIndex % 2
        halfWipeTransition.progress = smoothStep(0, 0.5, time)
    }
}
