//
//  BCMFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 13/7/23.
//

import Foundation

import MetalPetal

public class BCMFilter: NSObject, MTIUnaryFilter {
    
    public let context = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    public override init() { }

    public var inputImage: MTIImage?
    
    var supportImages: [MTIImage] {
        return [MTIImage]()
    }
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    var fragmentName: String { return "" }

    var parameters: [String: Any] { return [String: Any]()}
    var samplers: [String: String] { return [:] }
    
    public var outputImage: MTIImage? {
        guard let input = inputImage else {
            return inputImage
        }
        
        var images: [MTIImage] = [input]
        
        images.append(contentsOf: supportImages)
        
        let outputDescriptors = [ MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]
        
        var params = parameters
        params["ratio"] = Float(input.size.width / input.size.height)
        
        let output = kernel.apply(to: images, parameters: params, outputDescriptors: outputDescriptors).first
        return output
    }
    
    var kernel: MTIRenderPipelineKernel {
        
        var vertexDescriptor:MTIFunctionDescriptor!
        
        vertexDescriptor = MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName)
        
        let fragmentDescriptor = MTIFunctionDescriptor(name: fragmentName, libraryURL: MTIDefaultLibraryURLForBundle(Bundle(for: BCMTransition.self)))
    
        return  MTIRenderPipelineKernel(vertexFunctionDescriptor: vertexDescriptor, fragmentFunctionDescriptor: fragmentDescriptor)
        
    }

}
