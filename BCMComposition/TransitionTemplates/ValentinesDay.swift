//
//  ValentinesDay.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class ValentinesDay: BCMTransitionTemplate {

    let upWipe = MTWipeUpTransition()
    let downWipe = MTWipeDownTransition()
    let overlayFilter = OverlayFilter()
    
    var transition :BCMTransition!
    
    
    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "valentine-day"))

    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => transition.inputPorts.inputImage
            source.forgroundImage => transition.inputPorts.destImage
            
            transition => overlayFilter => output
        }
        
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        
        if source.currentAssetIndex % 2 == 0{
            transition = upWipe
        }else{
            transition = downWipe
        }
        
        transition.progress = time
        
    }
    
    
}
