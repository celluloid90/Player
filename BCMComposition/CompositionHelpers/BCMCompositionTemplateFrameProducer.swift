//
//  BCMCompositionFrameProducer.swift
//  BCMComposition
//
//  Created by BCL Device7 on 19/9/23.
//

import UIKit
import MetalPetal

public class BCMCompositionTemplateFrameProducer: NSObject {

    var bcmAssets: [BCMAsset] = [BCMAsset]()

    private var currentAssetIndex = -1

    private var oneInFg = false
    
    var forgroundImage : MTIImage!
    var backgroundImage : MTIImage!

    private var frameGeneratorOne = BCMFrameGenerator()
    private var frameGeneratorTwo = BCMFrameGenerator()

    var frameSize: CGSize = .zero
    
    public init(bcmAssets: [BCMAsset]) {
        self.bcmAssets = bcmAssets
    }
    
    func setup() -> Void {
        
    }
    
    func changeSlide(drawFrag: Int) {
        
        if(drawFrag != currentAssetIndex) {
            oneInFg = !oneInFg
            currentAssetIndex = drawFrag
        }

        print("AS101", "############ changeSlide: \(drawFrag) \(currentAssetIndex)##############")
        
        if drawFrag == 0{
            if oneInFg{
                frameGeneratorTwo.setAsset(bcmAsset: bcmAssets[bcmAssets.count - 1])
            }else{
                frameGeneratorOne.setAsset(bcmAsset: bcmAssets[bcmAssets.count - 1])
            }
        }
        
        if oneInFg{
            frameGeneratorOne.setAsset(bcmAsset: bcmAssets[currentAssetIndex % bcmAssets.count])
        }else{
            frameGeneratorTwo.setAsset(bcmAsset: bcmAssets[currentAssetIndex % bcmAssets.count])
        }
        
    }
    
    func clear() -> Void {
        
    }
    
    public func draw(progress: Float) -> Void {

        if oneInFg{
            forgroundImage =  frameGeneratorOne.getFrame(progress: progress)
            backgroundImage = frameGeneratorTwo.getFrame(progress: progress)
        }else{
            forgroundImage =  frameGeneratorTwo.getFrame(progress: progress)
            backgroundImage = frameGeneratorOne.getFrame(progress: progress)
        }
    }
    
}
