//
//  BorderFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 29/3/23.
//

import UIKit
import MetalPetal

class BorderFilter: MTIUnaryImageRenderingFilter {
    
    public var borderWidth: Float = 0.01
    public var borderColor: MTIColor = MTIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var ratio: Float = 0

    public override var parameters: [String : Any] {
        guard let input = self.inputImage else {return [:]}
        return [
            "borderWidth": borderWidth,
            "borderColor" : MTIVector(value: borderColor.toFloat4()),
            "ratio" : Float(input.size.width / input.size.height),

        ]
    }
    
    public override class func fragmentFunctionDescriptor() -> MTIFunctionDescriptor {
        return MTIFunctionDescriptor(name: "BorderFilterFragment", libraryURL: MTIDefaultLibraryURLForBundle(Bundle.main))
    }
    
    public override var outputImage: MTIImage?{
        return super.outputImage
    }
}
