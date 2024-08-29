//
//  CrossZoomFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 15/3/23.
//

import Foundation
import MetalPetal

public class CrossZoomFilter: MTIUnaryImageRenderingFilter {
    
    public var intensity: Float = 0

    public override var parameters: [String : Any] {
        guard let input = self.inputImage else {return [:]}
        return [
            "ratio" : Float(input.size.width / input.size.height),
            "intensity": intensity,
        ]
    }
    
    public override class func fragmentFunctionDescriptor() -> MTIFunctionDescriptor {
        return MTIFunctionDescriptor(name: "CrossZoomFilterFragment", libraryURL: MTIDefaultLibraryURLForBundle(Bundle.main))
    }
    
    public override var outputImage: MTIImage?{
        return super.outputImage
    }
    
}
