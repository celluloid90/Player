//
//  MidSummer.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 15/5/23.
//

import UIKit
import MetalPetal

class MidSummer: BCMTransitionTemplate {
    let borderSwipe = BorderSwipeTransition()
    let tranformFilterFg = MTITransformFilter()
    let tranformFilterBg = MTITransformFilter()
    let tranformFilterBlend = MTITransformFilter()

    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let saturationFilter = MTISaturationFilter()

    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage.oriented(.downMirrored) => tranformFilterBlend => blendFilter.inputPorts.inputBackgroundImage
            
            source.forgroundImage => saturationFilter => tranformFilterBg => borderSwipe.inputPorts.inputImage
            source.forgroundImage => tranformFilterFg => borderSwipe.inputPorts.destImage
            
            borderSwipe => blendFilter.inputPorts.inputImage
            
            blendFilter => output
        }
        
        return output
    }

    override func updateParams() {
        
        let time = source.currentProgress
        
        blendFilter.intensity = smoothStep(0, 0.1, time)
        tranformFilterBlend.transform = CATransform3DMakeScale(1.3, 1.3, 1)

        
        switch source.currentAssetIndex % 4 {
        case 0:
            borderSwipe.direction = MTIVector(x: 0, y: 0)
            break
        case 1:
            borderSwipe.direction = MTIVector(x: 0, y: 1)
            break
        case 2:
            borderSwipe.direction = MTIVector(x: 1, y: 0)
            break
        case 3:
            borderSwipe.direction = MTIVector(x: 1, y: 1)
            break
        default:
            break
        }
        
        tranformFilterFg.transform = CATransform3DMakeScale(1, 1, 1)
        tranformFilterBg.transform = CATransform3DMakeScale(1, 1, 1)
        
        var  borderTime = smoothStep(0.1, 0.9, time)
        borderTime = sin(borderTime * 3.1416 * 0.5)
        
        if borderTime < 0.5 {
            borderSwipe.progress = borderTime
            
        }else if borderTime >= 0.5 && borderTime < 0.7{
            borderSwipe.progress = 0.5
        }else{
            borderTime = smoothStep(0.7, 1, borderTime)
            
            borderSwipe.progress = borderTime * 0.5 + 0.5
            
            let scale = CGFloat(1 + borderTime * 0.3)
            tranformFilterFg.transform = CATransform3DMakeScale(scale, scale, 1)
            tranformFilterBg.transform = CATransform3DMakeScale(scale, scale, 1)

            print("progress \(scale) time \(borderSwipe.progress)")

        }

        saturationFilter.saturation = 0.1
        
    }
}
