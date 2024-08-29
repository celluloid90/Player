//
//  TwoTriangleTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit
import MetalPetal

class TwoTriangleTransition: BCMTransition {

    var angle:Float = -190
    var center = MTIVector(x: 0.5, y: 0.5)
    var a = MTIVector(x: 0, y: 0)
    var b = MTIVector(x: 1, y: 0)
    var c = MTIVector(x: 0.5, y: 1)

    override var fragmentName: String {
        return "TwoTriangleTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "angle" : angle,
            "center" : center,
            "a" : a,
            "b" : b,
            "c" : c
        ]
    }
    
}
