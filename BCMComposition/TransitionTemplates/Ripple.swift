//
//  Ripple.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 15/5/23.
//

import UIKit
import MetalPetal

class Ripple: BCMTransitionTemplate {

    var rippleTransition : MTICoreImageUnaryFilter!
    
    override func setup() {
        super.setup()
        
        var effect = BCMCIEffect()
        
        effect.filterName = "CIRippleTransition"
        effect.inputCenter = CIVector(x: renderSize.width / 2, y: renderSize.height / 2)
        effect.inputScale = 1
        effect.inputWidth = 100
        
        rippleTransition = MTICoreImageUnaryFilter(effect: effect)
        
        if let image = UIImage(named: "Shading.tiff"){
            let ciimage = CIImage(image: image)
            rippleTransition.filter?.setValue( ciimage, forKey: kCIInputShadingImageKey)
        }

    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        rippleTransition.inputImage = source.backgroundImage
        
        let size = source.backgroundImage.extent.size
        rippleTransition.setCenter(CIVector(x: size.width  / 2, y: size.height / 2))
        if let destImage = try? mtiContext?.makeCIImage(from: source.forgroundImage){
            rippleTransition.setTargetImage(destImage)
        }

        return rippleTransition.outputImage?.oriented(.downMirrored)
        
    }
    
    override func updateParams() {
        
        var time = source.currentProgress
        time = smoothStep(0, 0.3, time)
        rippleTransition.setInputTime(time)

    }
    
}
