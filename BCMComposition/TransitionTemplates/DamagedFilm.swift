//
//  DamagedFilm.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/5/23.
//

import UIKit
import MetalPetal

class DamagedFilm: BCMTransitionTemplate {

    var monoChromeFilter : MTICoreImageUnaryFilter!

    private let swipeFromMiddle = SwipeFromMiddleTransition()
    let transformFilterFG = MTITransformFilter()
    let transformFilterBG = MTITransformFilter()
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
        videoOverlayFilter = VideoOverlayFilter(video: BCMVideoItem(name: "3644414"))
        videoOverlayFilter.totalSlideShowTime = source.duration

        var effect = BCMCIEffect()
        effect.filterName = "CIColorMonochrome"
        effect.inputColor = [255,166,107]
        effect.inputIntensity = 0.7
        
        monoChromeFilter = MTICoreImageUnaryFilter(effect: effect)
        
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.backgroundImage
        swipeFromMiddle.destImage = source.forgroundImage
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => transformFilterBG => saturationFilter => monoChromeFilter => swipeFromMiddle.inputPorts.inputImage
            source.forgroundImage => transformFilterFG => saturationFilter => monoChromeFilter => swipeFromMiddle.inputPorts.destImage
            
            swipeFromMiddle => videoOverlayFilter.inputPorts.inputImage
            
            videoOverlayFilter => output
            
        }
        return output
    }
    
    override func updateParams() {
        
        
        let time = source.currentProgress
        videoOverlayFilter.progress = source.getVideoProgress()
        
        swipeFromMiddle.progress = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)

        var zTime = sin(smoothStep(0.5, 1, time) * Float.pi * 0.5)
        
        transformFilterFG.transform = CATransform3DMakeScale(CGFloat(1 + zTime * 0.025), CGFloat(1 + zTime * 0.025), 1)
        
        zTime = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)

        transformFilterBG.transform = CATransform3DMakeScale(CGFloat(1.025 + zTime * 0.025), CGFloat(1.025 + zTime * 0.025), 1)

        swipeFromMiddle.direction = 0
        
        saturationFilter.saturation = 0
        
        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
            
        }
        
    }
    
}
