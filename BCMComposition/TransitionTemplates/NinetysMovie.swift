//
//  NinetysMovie.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/5/23.
//

import UIKit
import MetalPetal

class NinetysMovie: BCMTransitionTemplate {
    
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let saturationFilter = MTISaturationFilter()
    
    var videoOverlayFilter : VideoOverlayFilter!
    override var renderSize: CGSize{
        didSet{
            videoOverlayFilter.frameSize = renderSize
        }
    }
    override var sliderValueChanging: Bool {
        didSet{
            videoOverlayFilter.sliderValueChanging(value: sliderValueChanging)

        }
    }
    
    override func setup() {
        super.setup()
        videoOverlayFilter = VideoOverlayFilter(video: BCMVideoItem(name: "29304319"))
        videoOverlayFilter.totalSlideShowTime = source.duration

    }
    
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => saturationFilter => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage  => saturationFilter => blendFilter.inputPorts.inputImage
            
            blendFilter => videoOverlayFilter.inputPorts.inputImage
            
            videoOverlayFilter => output
        }
        return output?.oriented(.downMirrored)
    }
    
    override func updateParams() {
        let time = source.currentProgress
        videoOverlayFilter.progress = source.getVideoProgress()

        blendFilter.intensity = smoothStep(0, 0.3, time)
        
        saturationFilter.saturation = 0
        
        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
        }
    }
    
}
