//
//  Friends.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 15/5/23.
//

import UIKit
import MetalPetal

class Friends: BCMTransitionTemplate {
    let transition = LineDrawOutTransition()
    let transformBg = MTITransformFilter()
    let transformFg = MTITransformFilter()

    override func setup() {
        
    }
    
    override func draw() -> MTIImage? {
        
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            
            source.backgroundImage  => transformBg => transition.inputPorts.inputImage
            source.forgroundImage => transformFg => transition.inputPorts.destImage
            
            transition => output
        }
    }
    
    override func updateParams() {
        
        let time = source.currentProgress
        
        switch source.currentAssetIndex % 2 {
        case 0:
            transition.p1 = MTIVector(x: 0, y: 0.5)
            transition.p2 = MTIVector(x: 1, y: 0.5)
            
            let zTime = smoothStep(0.2, 1, time)
            
            transformFg.transform = CATransform3DMakeScale(1 + CGFloat(zTime) / 5 , 1 + CGFloat(zTime) / 5, 0)
            transformBg.transform = CATransform3DMakeScale(1  , 1 , 0)
            
        case 1:
            transition.p1 = MTIVector(x: 0.5, y: 1)
            transition.p2 = MTIVector(x: 0.5, y: 0)
            
            let zTime = 1 - smoothStep(0.2, 1, time)
            
            transformFg.transform = CATransform3DMakeScale(1 + CGFloat(zTime) / 5 , 1 + CGFloat(zTime) / 5, 0)
            transformBg.transform = CATransform3DMakeScale(1 + 1 / 5 , 1 + 1 / 5, 0)
            
        default:
            break
        }
                
        transition.thickness = 0.15
        
        transition.progress = Float(time)
        
    }
}
