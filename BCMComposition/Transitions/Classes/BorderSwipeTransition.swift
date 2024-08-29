//
//  BorderSwipeTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 27/3/23.
//

import UIKit
import MetalPetal

public class BorderSwipeTransition: BCMTransition {
    public var length: Float = 0.005
    public var direction = MTIVector(x: 0, y: 0)

    override var fragmentName: String {
        return "BorderSwipeFragment"
    }

    override var parameters: [String: Any] {
        return [
            "dir": direction,
            "len" : length
        ]
    }
}
