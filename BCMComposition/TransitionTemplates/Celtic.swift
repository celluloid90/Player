//
//  Celtic.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 29/3/23.
//

import UIKit
import MetalPetal

public class Celtic: BCMTransitionTemplate {

    let transformFilterFG = MTITransformFilter()
    let transformFilterBG = MTITransformFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    public override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => transformFilterBG => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => transformFilterFG => blendFilter.inputPorts.inputImage

            blendFilter => output
        }
        
        return output?.oriented(.downMirrored)
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        let width = renderSize.width * RETINA_SCALE
        
        var progress = Float(sin(smoothStep(0, 0.7, time) * Float.pi * 0.5))
        blendFilter.intensity = progress
        
        var trans = Float(sin(smoothStep(0.7, 1, time) * Float.pi * 0.5) * 0.02)

        if source.currentAssetIndex % 2 == 0{
            progress = 1 - progress
            trans = -trans
            transformFilterBG.transform = CATransform3DMakeTranslation(0.02 * width, 1, 1)

        }else{
            progress = progress - 1
            transformFilterBG.transform = CATransform3DMakeTranslation(-0.02 * width, 1, 1)
        }
        
        if time > 0.7{
            
            transformFilterFG.transform = CATransform3DMakeTranslation(CGFloat(trans) * width, 1, 1)
        }else{
            
            transformFilterFG.transform = CATransform3DMakeTranslation(CGFloat(progress) * width, 1, 1)
            
        }
        
        transformFilterFG.transform = CATransform3DScale(transformFilterFG.transform, 1.2, 1.2, 1)

        transformFilterBG.transform = CATransform3DScale(transformFilterBG.transform,1.2, 1.2, 1)
        
    }
}
