//
//  Family.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit
import MetalPetal

class Family: BCMTransitionTemplate {

    let transformFilterFG = MTITransformFilter()
    let transformFilterBG = MTITransformFilter()
    let crossZoomFilter = CrossZoomFilter()
    
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    override func setup() {
        
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => transformFilterBG => crossZoomFilter => blendFilter.inputPorts.inputBackgroundImage
            
            source.forgroundImage => transformFilterFG => crossZoomFilter => blendFilter.inputPorts.inputImage
            blendFilter => output
        }
        
        return output?.oriented(.downMirrored)
        
    }
    
    override func updateParams() {
        var time = source.currentProgress
            
        var scale:Float = 3
        
        if time <= 0.2{
            scale = 3 - time * 9
            crossZoomFilter.intensity = 0.4 - time * 1.5
        }else {
            scale = 1.2 - smoothStep(0.2, 1, time) * 0.2
            crossZoomFilter.intensity = 0.1 - smoothStep(0.2, 0.3, time) * 0.1
        }
        
        transformFilterFG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
        
        scale = 1 - smoothStep(0, 0.1, time) * 0.5
        
        transformFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
        
        blendFilter.intensity = 0.7 + smoothStep(0, 0.1, time) * 0.3
        
    }
    
}
