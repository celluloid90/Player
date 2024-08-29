//
//  HalfDirectionalWipeTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 29/3/23.
//

import UIKit
import MetalPetal

class Nostalgic: BCMTransitionTemplate {

    let halfWipeTransition = HalfDirectionalWipeTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => halfWipeTransition.inputPorts.inputImage
            source.forgroundImage => halfWipeTransition.inputPorts.destImage
            
            halfWipeTransition => output
        }

    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        halfWipeTransition.direction = source.currentAssetIndex % 2
        halfWipeTransition.progress = smoothStep(0, 0.5, time)
    }
}
