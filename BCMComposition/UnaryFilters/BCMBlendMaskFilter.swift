//
//  BCMBlendMaskFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 13/7/23.
//

import Foundation
import MetalPetal

class BCMBlendMaskFilter: BCMFilter{
    var mask: MTIMask?
    var inputBackgroundImage: MTIImage?
    var intensity: Float = 1
    
    override var fragmentName: String{
        return "BCMBlendMaskFilterFragment"
    }
    
    override var parameters: [String : Any]{
        guard let mask else {
            return [:]
        }
        return [
            "maskComponent" : mask.component.rawValue,
            "intensity" : intensity
        ]
    }
    
    override var supportImages: [MTIImage]{
        guard let inputBackgroundImage, let mask else {
            return [MTIImage]()
        }
        return [inputBackgroundImage,mask.content]
    }

    
}
