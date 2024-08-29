//
//  Illusion.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/5/23.
//

import UIKit
import MetalPetal

class Illusion: BCMTransitionTemplate {

    let angular = MTAngularTransition()
    let transformFilter = MTITransformFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => angular.inputPorts.inputImage => blendFilter.inputPorts.inputBackgroundImage
            
            source.forgroundImage => transformFilter => blendFilter.inputPorts.inputImage
            
            blendFilter => angular.inputPorts.destImage
            
            angular => output
            
        }
        
        return output
        
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = smoothStep(0, 0.5, time)
        
        transformFilter.transform = CATransform3DMakeScale(1, 1, 1)
        blendFilter.intensity = time
        
        switch source.currentAssetIndex % 4 {
        case 0:
            blendFilter.intensity = 0.5 + time / 2
            angular.center = MTIVector(x: 0.5, y: 0.5)
            angular.startingAngle = 270
            angular.direction = 0
            angular.isTwoDirectional = 1
            
            if time <= 0.5{
                let scale = CGFloat(1 + time / 10)
                transformFilter.transform = CATransform3DMakeScale(scale, scale, 1)
                angular.progress = sin(time * 2 * Float.pi * 0.5) / 2
            }else if time <= 1{
                let scale = CGFloat(1.05 - smoothStep(0.5, 1, time) / 20)
                transformFilter.transform = CATransform3DMakeScale(scale, scale, 1)
                angular.progress = 0.5 + sin((time - 0.5) * 2 * Float.pi * 0.5) / 2
            }else{
                angular.progress = 1
            }

            break
        case 1:
            
            angular.center = MTIVector(x: 0.5, y: 0.5)
            angular.startingAngle = 90
            angular.direction = 0
            angular.isTwoDirectional = 0
            angular.progress = sin(time * Float.pi * 0.5)

            break
        case 2:
            angular.center = MTIVector(x: 0.5, y: 0.5)
            angular.startingAngle = 90
            angular.direction = 1
            angular.isTwoDirectional = 0
            angular.progress = sin(time * Float.pi * 0.5)
            
        case 3:
            
            blendFilter.intensity = 0.5 + time / 2

            angular.center = MTIVector(x: 0.5, y: 0.5)
            angular.startingAngle = 90
            angular.direction = 0
            angular.isTwoDirectional = 1
            
            if time <= 0.5{
                let scale = CGFloat(1 + time / 10)
                transformFilter.transform = CATransform3DMakeScale(scale, scale, 1)
                angular.progress = sin(time * 2 * Float.pi * 0.5) / 2
            }else if time <= 1{
                let scale = CGFloat(1.05 - smoothStep(0.5, 1, time) / 20)
                transformFilter.transform = CATransform3DMakeScale(scale, scale, 1)
                angular.progress = 0.5 + sin((time - 0.5) * 2 * Float.pi * 0.5) / 2
            }else{
                transformFilter.transform = CATransform3DMakeScale(1, 1, 1)
                angular.progress = 1
            }
            
        default:
            break
        }
        
    }
}
