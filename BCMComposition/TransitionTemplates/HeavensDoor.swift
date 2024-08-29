//
//  HeavensDoor.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit
import MetalPetal

class HeavensDoor: BCMTransitionTemplate {

    let doorWayFilter = DoorWayTransition()

    override func draw() -> MTIImage? {
        _ = super.draw()
        
        doorWayFilter.inputImage = source.backgroundImage
        doorWayFilter.destImage = source.forgroundImage
        
        return doorWayFilter.outputImage
    }
    
    override func updateParams() {
        let time = source.currentProgress
                
        doorWayFilter.progress = smoothStep(0, 0.8, time)
    }
}
