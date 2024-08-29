//
//  OldTv.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/5/23.
//

import UIKit
import MetalPetal

class OldTv: BCMTransitionTemplate {
    
    private let swipeFromMiddle = SwipeFromMiddleTransition()

    let saturationFilter = MTISaturationFilter()
    let transformFilter = MTITransformFilter()
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
        videoOverlayFilter = VideoOverlayFilter(video: BCMVideoItem(name: "1007581312"))
        videoOverlayFilter.totalSlideShowTime = source.duration

    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        swipeFromMiddle.inputImage = source.backgroundImage
        swipeFromMiddle.destImage = source.forgroundImage
        
        let output = FilterGraph.makeImage { output in
            source.backgroundImage => saturationFilter => swipeFromMiddle.inputPorts.inputImage
            source.forgroundImage => saturationFilter => transformFilter => swipeFromMiddle.inputPorts.destImage
            
            swipeFromMiddle => videoOverlayFilter.inputPorts.inputImage
            
            videoOverlayFilter => output
        }
        return output
    }
    
    override func updateParams() {
        
        let time = source.currentProgress
        videoOverlayFilter.progress = source.getVideoProgress()

        let tTime  = sin(smoothStep(0, 0.5, time) * Float.pi * 0.5)
        swipeFromMiddle.progress = tTime
        videoOverlayFilter.overlayOpacity = 0.3
        saturationFilter.saturation = 0
        
        if currentAssetIndex % 2 == 0{
            swipeFromMiddle.direction = 0
            transformFilter.transform = CATransform3DMakeTranslation(CGFloat((tTime - 1) * 30), 1, 1)

        }else{
            swipeFromMiddle.direction = 1
            transformFilter.transform = CATransform3DMakeTranslation(1, CGFloat((tTime - 1) * 30), 1)
        }
        
        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
        }
        
    }
}
