//
//  LatinSurprise.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 25/5/23.
//

import UIKit
import MetalPetal

class LatinSunrise: BCMTransitionTemplate {
    
    let gaussianBlurFG = MTIMPSGaussianBlurFilter()
    let gaussianBlurBG = MTIMPSGaussianBlurFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let angular = MTAngularTransition()
    

    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => gaussianBlurBG => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => blendFilter.inputPorts.inputImage
            
            blendFilter => gaussianBlurBG => angular.inputPorts.inputImage
            source.forgroundImage => angular.inputPorts.destImage
            
            angular => gaussianBlurFG => output
            
        }
        
        return output
    }
    
    override func updateParams() -> Void {
        let time = source.currentProgress
        
        gaussianBlurBG.radius = 15
        gaussianBlurFG.radius = smoothStep(0.9, 1, time) * 15

        blendFilter.intensity = smoothStep(0,0.1, time)
        
        angular.center = MTIVector(x: 0.5, y: 0.5)
        angular.startingAngle = 90
        angular.progress = smoothStep(0, 0.6, time)
    }
}
