//
//  LineDrawOutTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/3/23.
//

import UIKit
import MetalPetal

class LineDrawOutTransition: BCMTransition {

    var p1 = MTIVector(x: 0, y: 0)
    var p2 = MTIVector(x: 1, y: 1)
    var thickness: Float = 0.01
    
    override var fragmentName: String {
        return "LineDrawOutFragment"
    }

    override var parameters: [String: Any] {
        return [
            "p1": p1,
            "p2" : p2,
            "thickness": thickness
        ]
    }
    
}
