//
//  Flutter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 16/3/23.
//

import Foundation
import MetalPetal

class Flutter: BCMTransitionTemplate {
    let twoTriangle = TwoTriangleTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage  => twoTriangle.inputPorts.inputImage
            source.forgroundImage  => twoTriangle.inputPorts.destImage
            
            twoTriangle => output
        }
        
    }
    
    override func updateParams() {
        
        let time = source.currentProgress
        twoTriangle.progress = time
        
    }

}
