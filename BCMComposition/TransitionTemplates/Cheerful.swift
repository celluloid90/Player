//
//  Cheerful.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

import UIKit
import MetalPetal

public class Cheerful: BCMTransitionTemplate {
    
    let centerBoxFilter = CenterBoxTransition()
    let transfromFilterFG = MTITransformFilter()
    let transfromFilterBG = MTITransformFilter()
    
    let gaussianBlurFG = MTIMPSGaussianBlurFilter()
    let gaussianBlurBG = MTIMPSGaussianBlurFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let angular = MTAngularTransition()

    public override func setup() {
//        source.animDurations = Array(repeating: 3.3, count: 4)
//        source.transitionDurations = Array(repeating: 1.5, count: 4)
//        source.calculateTime()
    }

    public override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => transfromFilterBG => gaussianBlurBG => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => blendFilter.inputPorts.inputImage
            
            blendFilter => gaussianBlurBG => centerBoxFilter.inputPorts.inputImage
            
            centerBoxFilter.inputPorts.inputImage => angular.inputPorts.inputImage
            
            if source.currentAssetIndex % 4 == 0 {
            //if true {
                source.forgroundImage => transfromFilterFG => centerBoxFilter.inputPorts.destImage
                centerBoxFilter => gaussianBlurFG => output
                
            }else{
                
                source.forgroundImage => transfromFilterFG => angular.inputPorts.destImage
                angular => gaussianBlurFG => output
                
            }
        }
        
        return output
    }
    
    override func updateParams() -> Void {
        let time = source.currentProgress
        
        gaussianBlurBG.radius = 15
        gaussianBlurFG.radius = smoothStep(0.9, 1, time) * 15

        blendFilter.intensity = smoothStep(0,0.1, time)
        
        switch source.currentAssetIndex % 4 {
        case 0:
            
            centerBoxAnim(time: time)
            scaleTransform(time: smoothStep(0.3, 1, time), direction: 1)

            break
        case 1:
            
            angular.center = MTIVector(x: 0, y: 0)
            angular.startingAngle = 0
            angular.progress = smoothStep(0, 0.6, time)
            scaleTransform(time: time, direction: -1)
            break
        case 2:
            angular.center = MTIVector(x: 0, y: 1)
            angular.startingAngle = 270
            angular.progress = smoothStep(0, 0.6, time)
            
            scaleTransform(time: time, direction: 1)
        case 3:
            angular.center = MTIVector(x: 0.5, y: 0.5)
            angular.startingAngle = 90
            angular.progress = smoothStep(0, 0.6, time)
            
            scaleTransform(time: time, direction: -1)
        default:
            break
        }
    }
    
    func centerBoxAnim(time:Float) -> Void {
        
        if time <= 0.1 {
            centerBoxFilter.angle = 45
            centerBoxFilter.radius = smoothStep(0, 0.1, time) / 2
        } else if time > 0.1 && time <= 0.22 {
            centerBoxFilter.angle = 45 - 45 * smoothStep(0.1, 0.22, time)

        }else if time >= 0.3{
            centerBoxFilter.angle = 0
            centerBoxFilter.radius = 0.5 + 0.5 * smoothStep(0.3, 0.4, time)
        }
        
    }
    
    func scaleTransform(time:Float, direction:Int) -> Void {
        var scale:Float = 1
        
        if direction == 0 {
            scale = 1.25 - time / 4
            transfromFilterBG.transform = CATransform3DMakeScale(1, 1, 1)

        }else{
            scale = 1 + time / 4
            transfromFilterBG.transform = CATransform3DMakeScale(1.25, 1.25, 1)
        }
        
        transfromFilterFG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 1)
        
    }
    
}
