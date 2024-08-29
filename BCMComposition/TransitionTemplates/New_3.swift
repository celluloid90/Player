//
//  New_3.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 6/6/23.
//

import UIKit
import MetalPetal

class New_3: BCMTransitionTemplate {
    let transformFilterFG = MTITransformFilter()
    let transformFilterBG = MTITransformFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    let videoOverlayFilter = VideoOverlayFilter()

    override var sliderValueChanging: Bool {
        didSet{
            videoOverlayFilter.sliderValueChanging(value: sliderValueChanging)
        }
    }
    override var renderSize: CGSize{
        didSet{
            videoOverlayFilter.frameSize = renderSize
        }
    }
    override func setup() {
        videoOverlayFilter.setCurrVideo(video: BCMVideoItem(name: "31287847-sd-preview"))
        videoOverlayFilter.totalSlideShowTime = source.duration
    }
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => transformFilterBG => blendFilter.inputPorts.inputBackgroundImage
            source.forgroundImage => transformFilterFG => blendFilter.inputPorts.inputImage

            blendFilter => videoOverlayFilter => output
        }
        
        return output?.oriented(.downMirrored)
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        videoOverlayFilter.progress = source.getVideoProgress()
        
        let height = renderSize.height * RETINA_SCALE
        
        var progress = Float(sin(smoothStep(0, 0.7, time) * Float.pi * 0.5))
        blendFilter.intensity = progress
        
        var trans = Float(sin(smoothStep(0.7, 1, time) * Float.pi * 0.5) * 0.02)
        
        progress = 1 - progress
        trans = -trans
        transformFilterBG.transform = CATransform3DMakeTranslation(1 , -0.02 * height, 1)
        
        if time > 0.7{
            
            transformFilterFG.transform = CATransform3DMakeTranslation(1, CGFloat(trans) * height, 1)
        }else{
            
            transformFilterFG.transform = CATransform3DMakeTranslation(1, CGFloat(progress) * height, 1)
            
        }
        
        transformFilterFG.transform = CATransform3DScale(transformFilterFG.transform, 1.2, 1.2, 1)

        transformFilterBG.transform = CATransform3DScale(transformFilterBG.transform,1.2, 1.2, 1)
        
    }
}
