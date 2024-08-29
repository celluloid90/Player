//
//  HeartShapeTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

import UIKit
import MetalPetal

public class HeartShapeTransition: BCMTransition {

    var radius:Float = 0.3
    var center = MTIVector(x: 0.5, y: 0.5)
    
    override var fragmentName: String {
        return "HeartShapeTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "radius": radius,
            "center" : center
        ]
    }
    
}
