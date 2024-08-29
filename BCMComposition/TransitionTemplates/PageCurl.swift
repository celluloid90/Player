//
//  PageCurl.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 16/5/23.
//

import UIKit
import MetalPetal

class PageCurl: BCMTransitionTemplate {
    var pageCurlTransition : MTICoreImageUnaryFilter!
    
    
    override func setup() {
        super.setup()
        
        var effect = BCMCIEffect()
        
        effect.filterName = "CIPageCurlTransition"
        effect.inputAngle = 0.785398
        
        
        pageCurlTransition = MTICoreImageUnaryFilter(effect: effect)
        
        if let image = UIImage(named: "Shading.tiff"){
            let ciimage = CIImage(image: image)
            pageCurlTransition.filter?.setValue( ciimage, forKey: kCIInputShadingImageKey)
        }

    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        pageCurlTransition.inputImage = source.backgroundImage
        
        let extent = source.backgroundImage.extent
        pageCurlTransition.filter?.setValue( CIVector(x: 0, y: 0, z: extent.width / 2, w: extent.height / 2), forKey: kCIInputExtentKey)
        pageCurlTransition.filter?.setValue( NSNumber(value: extent.width / 2), forKey: kCIInputRadiusKey)

        if let destImage = try? mtiContext?.makeCIImage(from: source.forgroundImage){
            pageCurlTransition.setTargetImage(destImage)
        }

        let output = pageCurlTransition.outputImage?.oriented(.downMirrored)
        return output
    }
    
    override func updateParams() {
        
        var time = source.currentProgress
        time = smoothStep(0, 0.3, time)
        pageCurlTransition.setInputTime(time)

    }
}
