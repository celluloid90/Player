//
//  MixWipeFilter.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/3/23.
//

import UIKit
import MetalPetal

class MixWipeTransition: BCMTransition {
    
    var width:Float = 0.1
    var direction = 0
    
    override var fragmentName: String {
        return "MixWipeTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "width" : width,
            "direction" : direction
        ]
    }
}
