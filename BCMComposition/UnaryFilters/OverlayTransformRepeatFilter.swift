//
//  OverlayTranslationFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/8/23.
//

import UIKit
import MetalPetal

class OverlayTransformRepeatFilter: MTIUnaryFilter {
    
    private let blendFilter = MTIBlendFilter(blendMode: .normal)
    private var mtiContext = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    let tileCIFilter = CIFilter(name: "CIAffineTile")
    let cropCIFilter = CIFilter(name: "CICrop")

    var opacity : Float = 0{
        didSet{
            blendFilter.intensity = opacity
        }
    }
    
    private var affineTransfrom : CGAffineTransform?{
        return CATransform3DGetAffineTransform(transform)
    }
    
    var transform : CATransform3D = CATransform3DIdentity
    
    var progress: Float = 0
    
    var inputImage: MTIImage?
    var chageInputOrientation = false
    
    var overlayItem: BCMOverlayItem!{
        didSet{
            overlayImage = overlayItem.mtiImage
        }
    }
    
    private var overlayImage: MTIImage!
    
    var outputPixelFormat: MTLPixelFormat = .invalid
    
    var frameSize :CGSize = .zero{
        didSet{
            overlayImage = overlayItem.mtiImage.centerCropped(frameSize)
        }
    }
    
    var overlaySize : CGSize {
        return overlayImage.extent.size
    }

    var outputImage: MTIImage?{
        
        guard let inputImage, let overlayImage else {
            return nil
        }
        
        var overlayCi = try? mtiContext?.makeCIImage(from: overlayImage)
        
        tileCIFilter?.setValue(affineTransfrom, forKey: "inputTransform")
        tileCIFilter?.setValue(overlayCi, forKey: "inputImage")
        
        overlayCi = tileCIFilter?.outputImage
        
        cropCIFilter?.setValue(overlayCi, forKey: "inputImage")
        
        let cropRect = CIVector(cgRect: CGRect(origin: .zero, size: CGSize(width: overlayImage.extent.width, height: overlayImage.extent.height)))
        cropCIFilter?.setValue(cropRect, forKey: "inputRectangle")
        
        overlayCi = cropCIFilter?.outputImage

        guard let overlayCi else {return nil}

        let tiledOutput = MTIImage(ciImage: overlayCi).premultiplyingAlpha()
                
        blendFilter.inputBackgroundImage = chageInputOrientation ? inputImage.oriented(.downMirrored) : inputImage

        let output = FilterGraph.makeImage { output in
            tiledOutput => blendFilter.inputPorts.inputImage
            blendFilter => output
        }
        
        return output
        
    }
}
