//
//  Soul.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/3/23.
//

import UIKit
import MetalPetal

public class Soul: BCMTransitionTemplate {

    let mixWipeTransition = MixWipeTransition()
    
    public override func draw() -> MTIImage? {
        _ = super.draw()
        
        mixWipeTransition.inputImage = source.backgroundImage
        mixWipeTransition.destImage = source.forgroundImage
        
        return mixWipeTransition.outputImage
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        mixWipeTransition.progress = smoothStep(0, 0.15, time)
        mixWipeTransition.width = 0.5
    }
    
}
