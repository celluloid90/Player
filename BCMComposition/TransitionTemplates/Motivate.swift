//
//  Motivate.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/3/23.
//

import UIKit
import MetalPetal

class Motivate: BCMTransitionTemplate {

    let blendFilter = MTIBlendFilter(blendMode: .normal)
    private let swipeFromMiddle = SwipeFromMiddleTransition()
    let transformFilterFG = MTITransformFilter()
    let transformFilterBG = MTITransformFilter()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        blendFilter.inputBackgroundImage = source.backgroundImage
        blendFilter.inputImage = source.forgroundImage
        
        swipeFromMiddle.inputImage = source.backgroundImage
        swipeFromMiddle.destImage = source.forgroundImage
        
        if source.currentAssetIndex % 2 == 0{
            let output = FilterGraph.makeImage { output in
                source.backgroundImage => blendFilter.inputPorts.inputBackgroundImage
                source.forgroundImage => transformFilterFG => blendFilter.inputPorts.inputImage
                
                blendFilter => output
            }
            return output?.oriented(.downMirrored)
        }else{
            let output = FilterGraph.makeImage { output in
                source.backgroundImage => transformFilterBG => swipeFromMiddle.inputPorts.inputImage
                source.forgroundImage => swipeFromMiddle.inputPorts.destImage
                swipeFromMiddle => output
            }
            
            return output
        }
    }
    
    override func updateParams() {
        
        let time = source.currentProgress
        transformFilterFG.transform = CATransform3DMakeScale(CGFloat(1 + time * 0.2), CGFloat(1 + time * 0.2), 1)
        transformFilterBG.transform = CATransform3DMakeScale(1.2, 1.2, 1)

        blendFilter.intensity = smoothStep(0, 0.1, time)
        swipeFromMiddle.direction = (source.currentAssetIndex % 3) % 2
        swipeFromMiddle.progress = smoothStep(0, 0.5, time)
    }
    
}
