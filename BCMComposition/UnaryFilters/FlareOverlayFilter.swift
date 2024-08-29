//
//  FlareOverlayFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/8/23.
//

import UIKit
import MetalPetal
import simd

class FlareOverlayFilter: BCMFilter {

    
    override var fragmentName: String{
        return "flareOverlayFragment"
    }
    
    var oneColor : SIMD4<Float> = SIMD4<Float>(0.05, 0.05, 0.05, 0.05)
    var twoColor : SIMD4<Float> = SIMD4<Float>(0.01, 0.01, 0.01, 0.01)
    var oneRadius : Float = 3.0
    var twoRadius : Float = 0.8
    var flareType : Int = 1 // 1 or 2
    var progress : Float = 0
    
    override var parameters: [String : Any]{

        return [
            "oneColor" : oneColor,
            "oneRadius" : oneRadius,
            "twoColor" : twoColor,
            "twoRadius" : twoRadius,
            "flareType" : flareType,
            "progress" : progress
        ]
    }

}
