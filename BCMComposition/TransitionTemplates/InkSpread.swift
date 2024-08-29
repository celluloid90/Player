//
//  InkSpread.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

class InkSpread: BCMTransitionTemplate {
    var videoTransition : BCMVideoTransition!
    
    override var sliderValueChanging: Bool {
        didSet{
            videoTransition.sliderValueChanging(value: sliderValueChanging)
        }
    }
    override var renderSize: CGSize{
        didSet{
            videoTransition.frameSize = renderSize
        }
    }
    override func setup() {
        
        videoItems = [BCMVideoItem(name: "ink_1_1"),BCMVideoItem(name: "ink_1_2")]
        
        videoTransition = BCMVideoTransition(video: videoItems[0])

    }
    
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        videoTransition.inputImage = source.backgroundImage
        videoTransition.destImage = source.forgroundImage
        
        return videoTransition.outputImage
    }
    
    override func updateParams() {
        let time = source.currentProgress

        if currentAssetIndex != source.currentAssetIndex{
            currentAssetIndex = source.currentAssetIndex
            
            videoTransition.setCurrVideo(video: videoItems[currentAssetIndex % 2])
            
        }
        
        videoTransition.progress = time
        
    }
    
    override func speedValueChanged() {
        videoTransition.setVideoSpeed(value: source.getSpeed())
    }
}
