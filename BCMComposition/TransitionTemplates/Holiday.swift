//
//  Holiday.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 12/7/23.
//

import UIKit
import MetalPetal

class Holiday: BCMTransitionTemplate {

    let transformFilter = MTITransformFilter()
    let blurFilter = MTIMPSGaussianBlurFilter()
    let maskBlendFilter = BCMBlendMaskFilter()
    let blendFilter = MTIBlendFilter(blendMode: .normal)
    
    override func setup() {
        if let image = UIImage(named: "Flag_of_Spain"){
            maskBlendFilter.mask = MTIMask(content: MTIImage(image: image).unpremultiplyingAlpha(), component: .red, mode: .normal)
        }
    }
        
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        let output = FilterGraph.makeImage { output in
            source.forgroundImage => blurFilter => blendFilter.inputPorts.inputBackgroundImage => maskBlendFilter.inputPorts.inputBackgroundImage
            
            source.forgroundImage => transformFilter => blendFilter.inputPorts.inputImage => maskBlendFilter.inputPorts.inputImage
            
            blendFilter => maskBlendFilter => output
        }
        
        return output
    }
    
    override func updateParams() {
        var time = source.currentProgress
        blendFilter.intensity = smoothStep(0, 0.3, time)
        time = time / 10
        blurFilter.radius = 20
        maskBlendFilter.intensity = 0
        
        transformFilter.transform = CATransform3DMakeTranslation(0, CGFloat(((source.currentAssetIndex % 2) != 0) ? time : -time) * renderSize.height , 0)
    }
}
