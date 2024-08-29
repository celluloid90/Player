//
//  EffectTemplate.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 19/7/23.
//

import UIKit
import MetalPetal

class EffectTemplate: BCMTransitionTemplate {
    var videoTransition : BCMVideoTransition!
    let videoOverlayFilter = VideoOverlayFilter()

    override var sliderValueChanging: Bool {
        didSet{
            videoOverlayFilter.sliderValueChanging(value: sliderValueChanging)
            videoTransition.sliderValueChanging(value: sliderValueChanging)
        }
    }
    override var renderSize: CGSize{
        didSet{
            videoTransition.frameSize = renderSize
            videoOverlayFilter.frameSize = renderSize
        }
    }
    override func setup() {
        videoItems = [BCMVideoItem(name: "31a")]

        videoTransition = BCMVideoTransition(video: videoItems[0])
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "31a"))
        videoOverlayFilter.totalSlideShowTime = source.duration
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        return FilterGraph.makeImage { output in
            source.backgroundImage => videoTransition.inputPorts.inputImage
            source.forgroundImage => videoTransition.inputPorts.destImage
            videoTransition => videoOverlayFilter => output
        }
    }
    
    override func updateParams() {
        let time = source.currentProgress
        videoOverlayFilter.progress = time

        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
            
            videoTransition.setCurrVideo(video: videoItems[currentAssetIndex % videoItems.count])
            
        }
        
        videoTransition.progress = time
        
    }
}
