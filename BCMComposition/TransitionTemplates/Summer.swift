//
//  Summer.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class Summer: BCMTransitionTemplate {
    
    let transformFilterFG = MTITransformFilter()
    let transformFilterBG = MTITransformFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let overlayFilter = OverlayFilter()


    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "SUMMER3"))
        overlayFilter.chageInputOrientation = true
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => transformFilterBG => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => transformFilterFG => blendFilter.inputPorts.inputImage

            blendFilter => overlayFilter => output
        }
        
        return output
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        
        let height = renderSize.height * RETINA_SCALE
        
        var progress = Float(sin(smoothStep(0, 0.7, time) * Float.pi * 0.5))
        blendFilter.intensity = progress
        
        var trans = Float(sin(smoothStep(0.7, 1, time) * Float.pi * 0.5) * 0.02)
        
        progress = 1 - progress
        trans = -trans
        transformFilterBG.transform = CATransform3DMakeTranslation(1 , -0.02 * height, 1)
        
        if time > 0.7{
            
            transformFilterFG.transform = CATransform3DMakeTranslation(1, CGFloat(trans) * height, 1)
        }else{
            
            transformFilterFG.transform = CATransform3DMakeTranslation(1, CGFloat(progress) * height, 1)
            
        }
        
        transformFilterFG.transform = CATransform3DScale(transformFilterFG.transform, 1.2, 1.2, 1)

        transformFilterBG.transform = CATransform3DScale(transformFilterBG.transform,1.2, 1.2, 1)
        
    }
}
