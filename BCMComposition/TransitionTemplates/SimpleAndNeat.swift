//
//  SimpleAndNeat.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/3/23.
//

import UIKit
import MetalPetal

class SimpleAndNeat: BCMTransitionTemplate {

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
        
        let time = CGFloat(source.currentProgress)
        
        switch source.currentAssetIndex % 4 {
        case 0:
            transition.p1 = MTIVector(x: 0, y: 0.5)
            transition.p2 = MTIVector(x: 1, y: 0.5)
        case 1:
            transition.p1 = MTIVector(x: 0.5, y: 0)
            transition.p2 = MTIVector(x: 0.5, y: 1)
        case 2:
            transition.p1 = MTIVector(x: 0, y: 0)
            transition.p2 = MTIVector(x: 1, y: 1)
        case 3:
            transition.p1 = MTIVector(x: 1, y: 0.5)
            transition.p2 = MTIVector(x: 0, y: 0.5)
        default:
            break
        }
                
        transformFg.transform = CATransform3DMakeScale(1 + time / 5 , 1 + time / 5, 0)
        transformBg.transform = CATransform3DMakeScale(1 + 1 / 5 , 1 + 1 / 5, 0)

        transition.progress = Float(time)
        
    }
    
}
