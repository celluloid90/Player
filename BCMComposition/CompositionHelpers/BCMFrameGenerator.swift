//
//  BCMFrameGenerator.swift
//  BCMComposition
//
//  Created by BCL Device7 on 24/9/23.
//

import UIKit
import MetalPetal

class BCMFrameGenerator: NSObject {

    var bcmAsset: BCMAsset!
    private lazy var videoFrameDecoder = BCMVideoFrameDecoder()
    
    var sliderValueChanging = false{
        didSet{
            if bcmAsset.type == .Video{
                videoFrameDecoder.sliderValueChanging = sliderValueChanging
            }
        }
    }
    
    init(bcmAsset: BCMAsset) {
        super.init()
        setAsset(bcmAsset: bcmAsset)
    }
    
    override init() {
        super.init()
    }
    
    func setAsset(bcmAsset: BCMAsset) -> Void {
        
        if self.bcmAsset != nil && bcmAsset == self.bcmAsset{
            return
        }
        
        if bcmAsset.type == .Video{
            
            videoFrameDecoder.setCurrVideo(url: bcmAsset.url)

        }else if bcmAsset.type == .Image {
            
        }
        self.bcmAsset = bcmAsset

    }
    
    func getFrame(progress: Float) -> MTIImage? {
        if bcmAsset.type == .Video{
            return videoFrameDecoder.getFrame(time: progress)

        }else if bcmAsset.type == .Image {
            return bcmAsset.mtiImage
        }
        return nil
    }
}
