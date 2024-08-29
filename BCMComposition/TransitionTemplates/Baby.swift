//
//  Baby.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/3/23.
//

import UIKit
import MetalPetal

class Baby: BCMTransitionTemplate {

    private let swipeFromMiddle = SwipeFromMiddleTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.forgroundImage
        swipeFromMiddle.destImage = source.backgroundImage
        
        return swipeFromMiddle.outputImage
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        swipeFromMiddle.direction = source.currentAssetIndex % 2
        
        swipeFromMiddle.progress = 1 - smoothStep(0, 0.5, time)

    }

}
