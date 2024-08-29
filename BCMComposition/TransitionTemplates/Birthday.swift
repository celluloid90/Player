//
//  Birthday.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class Birthday: BCMTransitionTemplate {
    let swipeFromMiddle = SwipeFromMiddleTransition()
    let overlayFilter = OverlayFilter()

    
    override var renderSize: CGSize{
        didSet{
            overlayFilter.frameSize = renderSize
        }
    }
    override func setup() {
        overlayFilter.overlayImage = MTIImage(sticker: BCMOverlayItem(name: "frame1"))
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        let output = FilterGraph.makeImage { output in
            
            swipeFromMiddle => overlayFilter => output
        }
        return output
    }
    
    override func updateParams() {
        var time = source.currentProgress
        time = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        
        if source.currentAssetIndex % 2 == 0{
            swipeFromMiddle.inputImage = source.backgroundImage
            swipeFromMiddle.destImage = source.forgroundImage
            
        }else{
            swipeFromMiddle.inputImage = source.forgroundImage
            swipeFromMiddle.destImage = source.backgroundImage
            time = 1 - time
        }
        
        
        swipeFromMiddle.progress = time
    }
}
