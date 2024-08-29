//
//  AdoreTemplate.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/8/23.
//

import UIKit
import MetalPetal

public class AdoreTemplate: BCMTransitionTemplate {

    let adoreTransition = AdoreTransition()
    let heartOverlay = OverlayTransformRepeatFilter()
    let dotOverlay = OverlayTransformRepeatFilter()
    let flareOverlay = FlareOverlayFilter()
    let contrastFilter = MTIContrastFilter()
    let transformFilter = MTITransformFilter()
    let prevTransformFilter = MTITransformFilter()

    let blurFilter = MTIMPSGaussianBlurFilter()
    
    override var renderSize: CGSize{
        didSet{
            heartOverlay.frameSize = renderSize
            dotOverlay.frameSize = renderSize
        }
    }
    
    public override func setup() {
        super.setup()
        
        heartOverlay.overlayItem = BCMOverlayItem(name: "love")
        dotOverlay.overlayItem = BCMOverlayItem(name: "dots")

        blurFilter.radius = 0
        
    }
    
    public override func draw() -> MTIImage? {
        _ = super.draw()
        
        let output = FilterGraph.makeImage { output in
            
            source.backgroundImage => contrastFilter => prevTransformFilter => flareOverlay => dotOverlay => heartOverlay => adoreTransition.inputPorts.inputImage
            
            source.forgroundImage => contrastFilter => transformFilter => blurFilter => flareOverlay => dotOverlay => heartOverlay => adoreTransition.inputPorts.destImage
            
            adoreTransition => output
            
        }
        
        return output
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        
        
        if(currentAssetIndex != source.currentAssetIndex) {
            currentAssetIndex = source.currentAssetIndex
            setLoveRotation()
            
        }
        var overlayTime: CGFloat = currentAssetIndex % 2 == 0 ? 0 : 0.5

        overlayTime = overlayTime + CGFloat(time / 2)
        
        var rotateTime: CGFloat = CGFloat(1.0 - time)
        
        var sTransform = CATransform3DMakeScale(1.25 + 0.25 * rotateTime, 1.25 + 0.25 * rotateTime, 0)
        var rTransform = CATransform3DMakeRotation(1/10 * rotateTime, 0, 0, 1)
        
        var transform = CATransform3DConcat(sTransform, rTransform)
        
        transformFilter.transform = transform
        
        rotateTime = CGFloat(time)
        
        sTransform = CATransform3DMakeScale(1.25 - 0.25 * rotateTime, 1.25 - 0.25 * rotateTime, 0)
        rTransform = CATransform3DMakeRotation(-1/10 * rotateTime, 0, 0, 1)
        
        transform = CATransform3DConcat(sTransform, rTransform)
        
        prevTransformFilter.transform = transform
        
        
        heartOverlay.transform = CATransform3DMakeTranslation(0, heartOverlay.overlaySize.height * overlayTime, 0)
        dotOverlay.transform = CATransform3DMakeTranslation(0, dotOverlay.overlaySize.height * (overlayTime * 2.0 - floor(overlayTime * 2.0)), 0)

        
        if (time > 0.3 && time < 0.5) {
            let t = (time - 0.3) / 0.2
            blurFilter.radius = sin(0.5 * Float.pi * t)
        } else {
            blurFilter.radius = 0
        }
        
        if time >= 0.3 && time <= 0.5{
            contrastFilter.contrast = 1 - smoothStep(0.3, 0.5, time) * 0.25
        }else if time >= 0.5 && time <= 0.7 {
            contrastFilter.contrast = 0.75 + smoothStep(0.5, 0.7, time) * 0.25
        }else{
            contrastFilter.contrast = 1
        }
        
        flareOverlay.progress = 0.25 + 0.75 * sin(Float.pi * time)
        adoreTransition.progress = sin(0.5 * Float.pi * time)
        
    }
    
    private func setLoveRotation() {
        adoreTransition.changeRotation(value: 0.4)
        adoreTransition.changeRotation(value: 3.0, pos: 8)
    }
}
