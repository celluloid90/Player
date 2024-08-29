//
//  VideoTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 2/4/23.
//

import UIKit
import MetalPetal

class BCMVideoTransition: BCMTransition {
    
    public var videoDecoder = BCMVideoFrameDecoder()
    public var videoImage: MTIImage?
    var frameSize :CGSize = .zero
    
    init(video:BCMVideoItem) {
        super.init()
        videoDecoder.setCurrVideo(url: video.url)
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    func setCurrVideo(video: BCMVideoItem) -> Void {
        videoDecoder.setCurrVideo(url: video.url)
    }
    
    func setVideoSpeed(value: Float) -> Void {
        videoDecoder.speed = value
    }
    
    override var fragmentName: String {
        return "VideoTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
             :
        ]
    }
    
    
    public override var outputImage: MTIImage? {
        guard let input = inputImage else {
            return inputImage
        }
        
        var images: [MTIImage] = [input]
        
        if let dest = destImage {
            images.append(dest)
        }
        
        if let vImage = videoDecoder.getFrame(time: progress)?.centerCropped(frameSize){
            images.append(vImage)
        }else{
            return destImage?.oriented(.downMirrored)
            print("video frame nil")
        }
        
        let outputDescriptors = [ MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)]
        
        var params = parameters
        params["ratio"] = Float(input.size.width / input.size.height)
        params["progress"] = progress
        
        let output = kernel.apply(to: images, parameters: params, outputDescriptors: outputDescriptors).first
        return output
    }
    
    func resetTrack() -> Void {
        videoDecoder.resetTrackReader()
    }
    
    func sliderValueChanging(value: Bool) -> Void {
        videoDecoder.sliderValueChanging = value
    }
}
