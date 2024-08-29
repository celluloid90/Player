//
//  OverlayFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 16/7/23.
//

import UIKit
import MetalPetal

class OverlayFilter: MTIUnaryFilter {
    
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    var opacity : Float = 0{
        didSet{
            blendFilter.intensity = opacity
        }
    }
    
    var inputImage: MTIImage?
    var chageInputOrientation = false
    
    var overlayImage: MTIImage?{
        didSet{
            blendFilter.inputImage = self.overlayImage
        }
    }
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var frameSize :CGSize = .zero

    var outputImage: MTIImage?{
        
        blendFilter.inputBackgroundImage = chageInputOrientation ? inputImage?.oriented(.downMirrored) : inputImage
        return blendFilter.outputImage
    }
}
