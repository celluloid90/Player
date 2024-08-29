//
//  FreeBirds.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 25/5/23.
//

import UIKit
import MetalPetal

public class FreeBirds: BCMTransitionTemplate {

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
        var time = source.currentProgress
        time = sin(time * Float.pi * 0.5)
        var scale:Float = 1
        
        if time <= 0.2{
            scale = 1 + smoothStep(0, 0.2, time) / 10
            transfromFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
        }
        else if time <= 0.5{
            scale = 1.1 + smoothStep(0.2, 0.5, time) / 2.5
            transfromFilterFG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
            transfromFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)

        }else {
            scale = 1.5 - smoothStep(0.5, 1, time) / 2
            transfromFilterFG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
        }
        
        blendFilter.intensity = smoothStep(0.2,0.4, time)


        gaussianBlurBG.radius = smoothStep(0.2, 0.3, time) * 5
        gaussianBlurFG.radius = 5 - smoothStep(0.3, 0.4, time) * 5

    }
    
}
