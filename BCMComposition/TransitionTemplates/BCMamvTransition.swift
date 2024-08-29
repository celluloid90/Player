//
//  BCMAMVTransition.swift
//  BCMTransitions
//
//  Created by BCL Device7 on 13/9/23.
//

import UIKit
import MetalPetal

public class BCMamvTransition: BCMTransitionTemplate {
    let transfromFilterFG = MTITransformFilter()
    let transfromFilterBG = MTITransformFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let gaussianBlurBG = MTIMPSGaussianBlurFilter()
    let gaussianBlurFG = MTIMPSGaussianBlurFilter()

    public override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => transfromFilterBG => gaussianBlurBG => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => transfromFilterFG => gaussianBlurFG => blendFilter.inputPorts.inputImage
            
            blendFilter => output
        }
        
        return output?.oriented(.downMirrored)
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        //time = sin(time * Float.pi * 0.5)
        var scale:Float = 1
//        print("currentAssetIndex \(currentAssetIndex)")
        if source.currentAssetIndex % 2 == 0{
            
            if time <= 0.7{
                scale = 1 + smoothStep(0, 0.7, time) / 10
                transfromFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
            }
            else{
                scale = 1.1 + smoothStep(0.7, 1, time) / 5
                transfromFilterFG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
                transfromFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
            }
        }else{
            
            if time <= 0.7{
                scale = 1.3 - smoothStep(0, 0.7, time) / 10
                transfromFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
            }
            else{
                scale = 1.2 - smoothStep(0.7, 1, time) / 5
                transfromFilterFG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
                transfromFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
            }
        }
        
        blendFilter.intensity = smoothStep(0.6,0.8, time)

        gaussianBlurBG.radius = smoothStep(0.6, 0.7, time) * 5
        gaussianBlurFG.radius = 5 - smoothStep(0.7, 0.8, time) * 5

    }
}
