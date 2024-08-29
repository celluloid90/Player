//
//  ThreeDRotate.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 2/4/23.
//

import UIKit
import MetalPetal

class ThreeDRotate: BCMTransitionTemplate {

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
        super.setup()
        
        videoItems = [BCMVideoItem(name: "3d_3_2"),BCMVideoItem(name: "3d_3_1")]
        
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
            
            videoTransition.setCurrVideo(video: videoItems[currentAssetIndex % videoItems.count])

        }
        
        videoTransition.progress = time
    }
    
}
