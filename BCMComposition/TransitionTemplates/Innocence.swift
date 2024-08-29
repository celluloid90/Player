//
//  Innocence.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

import UIKit
import MetalPetal

class Innocence: BCMTransitionTemplate {

    let bannerZoom = BannerZoomTransition()
    let transformFilterBG = MTITransformFilter()
    let transformFilter = MTITransformFilter()

    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.forgroundImage.oriented(.downMirrored) => transformFilter  => blendFilter.inputPorts.inputImage
            
            source.backgroundImage => transformFilterBG => bannerZoom.inputPorts.inputImage
            bannerZoom.inputPorts.inputImage => bannerZoom.inputPorts.destImage
            
            bannerZoom => blendFilter.inputPorts.inputBackgroundImage
            
            blendFilter => output
            
        }
        
        return output
        
    }
    
    override func updateParams() -> Void {
        var time = source.currentProgress
        
        blendFilter.intensity =  smoothStep(0.9, 1, time)
        
        time = smoothStep(0, 0.9, time)
        
        var scale = 1.1 - (1 - time) * 0.1
        transformFilter.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 0)
        
        scale = 1.1 - time * 0.1
        transformFilterBG.transform = CATransform3DMakeScale(CGFloat(scale), CGFloat(scale), 0)
        
        switch source.currentAssetIndex % 2 {
        case 0:
            bannerZoom.direction = 0
            break
        case 1:
            bannerZoom.direction = 1
            break
        default:
            break
        }
        
        bannerZoom.progress = time
        bannerZoom.thickness = 0.6
        bannerZoom.zoomFactor = 0.9
    }
    
}
