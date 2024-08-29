//
//  DoorWayTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit

public class DoorWayTransition: BCMTransition {

    public var reflection: Float = 0.4
    public var perspective:Float = 0.4
    public var depth:Float = 3

    override var fragmentName: String {
        return "DoorWayTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "reflection": reflection,
            "perspective" : perspective,
            "depth" : depth
        ]
    }
    
}
