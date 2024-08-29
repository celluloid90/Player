//
//  CenterBoxTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

import UIKit
import MetalPetal

public class CenterBoxTransition: BCMTransition {

    var angle:Float = 0
    var radius:Float = 0.2
    var center = MTIVector(x: 0.5, y: 0.5)
    
    override var fragmentName: String {
        return "CenterBoxTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "radius": radius,
            "angle": angle,
            "center" : center
        ]
    }
}
