//
//  Isolated.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 10/7/23.
//

import UIKit
import MetalPetal

class Isolated: BCMTransitionTemplate {
    
    let transformFilter = MTITransformFilter()
    var wipeTransition : BCMTransition!
    let wipeDown = MTWipeDownTransition()
    let wipeUp = MTWipeUpTransition()
    let wipeLeft = MTWipeLeftTransition()
    let wipeRight = MTWipeRightTransition()
    
    let blendFilter = MTIBlendFilter(blendMode: .normal)

    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => wipeTransition.inputPorts.inputImage
            
            source.backgroundImage => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => blendFilter.inputPorts.inputImage
            
            blendFilter => wipeTransition.inputPorts.destImage

            wipeTransition => output
        }
        
        return output
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        
        blendFilter.intensity = time
        
        switch source.currentAssetIndex % 4 {
        case 0:
            wipeTransition = wipeLeft
            break
        case 1:
            wipeTransition = wipeDown
            break
        case 2:
            wipeTransition = wipeRight
            break
        case 3:
            wipeTransition = wipeUp
            break
        default:
            break
        }
        
        wipeTransition.progress = time
        
    }
    
}
