//
//  BCMCompositionFrameProducer.swift
//  BCMComposition
//
//  Created by BCL Device7 on 21/9/23.
//

import UIKit
import MetalPetal

class BCMCompositionFrameProducer: NSObject {
    
    private var currentAssetIndex : Int = 0
    
    var bcmAssets: [BCMAsset] = [BCMAsset]()
    var foregroundImage : MTIImage!
    var backgroundImage : MTIImage?

    private var frameGeneratorBg : BCMFrameGenerator?
    private var frameGeneratorFg = BCMFrameGenerator()
    
    private var isBackward = false
    
    var sliderValueChanging = false{
        didSet{
            frameGeneratorBg?.sliderValueChanging = sliderValueChanging
            frameGeneratorFg.sliderValueChanging = sliderValueChanging
        }
    }
    
    public init(bcmAssets: [BCMAsset]) {
        self.bcmAssets = bcmAssets
    }
    
    func changeSlide(drawFrag: Int, transitioning: Bool) {
        currentAssetIndex = drawFrag
        print("current asset index \(currentAssetIndex)")
        isBackward = false
        
        if frameGeneratorFg.bcmAsset != nil,
           !(frameGeneratorFg.bcmAsset.order == bcmAssets.count - 1 && currentAssetIndex == 0) &&
            currentAssetIndex < frameGeneratorFg.bcmAsset.order{
            
            isBackward = true
        }else{
            isBackward = false
        }
        
        if transitioning{
            
            frameGeneratorBg = frameGeneratorFg
            
            if isBackward == true{
                frameGeneratorFg = BCMFrameGenerator(bcmAsset: bcmAssets[currentAssetIndex])
                frameGeneratorFg.sliderValueChanging = self.sliderValueChanging
            }else {
                
                frameGeneratorFg = BCMFrameGenerator(bcmAsset: bcmAssets[(currentAssetIndex + 1) % bcmAssets.count])
                frameGeneratorFg.sliderValueChanging = self.sliderValueChanging

            }

        }else{
            
            frameGeneratorFg = BCMFrameGenerator(bcmAsset: bcmAssets[currentAssetIndex])
            frameGeneratorFg.sliderValueChanging = self.sliderValueChanging

        }
        print("composition item order \(frameGeneratorBg?.bcmAsset.order ?? -1) : \(frameGeneratorFg.bcmAsset.order )")

    }
    
    func draw(progress: Float) -> Void {
        
        if isBackward {
            foregroundImage = frameGeneratorBg?.getFrame(progress: progress)
            backgroundImage = frameGeneratorFg.getFrame(progress: progress)

        }else{
            foregroundImage = frameGeneratorFg.getFrame(progress: progress)
            backgroundImage = frameGeneratorBg?.getFrame(progress: progress)
        }
    }
}
