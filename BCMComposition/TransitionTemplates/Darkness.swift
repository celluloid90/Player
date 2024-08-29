//
//  Darkness.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 10/7/23.
//

import UIKit
import MetalPetal

class Darkness: BCMTransitionTemplate {
    
    let transformFilter = MTITransformFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => transformFilter => blendFilter.inputPorts.inputImage

            blendFilter => output
        }
        
        return output?.oriented(.downMirrored)
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        let width = renderSize.width * RETINA_SCALE
        let height = renderSize.height * RETINA_SCALE

        var progress = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        blendFilter.intensity = progress

        switch source.currentAssetIndex % 4 {
        case 0:
            transformFilter.transform = CATransform3DMakeTranslation(CGFloat(progress - 1) * width, CGFloat(1 - progress) * height, 1)

            break
        case 1:
            transformFilter.transform = CATransform3DMakeTranslation(CGFloat(1 - progress) * width, CGFloat(1 - progress) * height, 1)

            break
        case 2:
            transformFilter.transform = CATransform3DMakeTranslation(CGFloat(1 - progress) * width, CGFloat(progress - 1) * height, 1)

            break
        case 3:
            transformFilter.transform = CATransform3DMakeTranslation(CGFloat(progress - 1) * width, CGFloat(progress - 1) * height, 1)

            break
        default:
            break
        }
        



        
    }
}
