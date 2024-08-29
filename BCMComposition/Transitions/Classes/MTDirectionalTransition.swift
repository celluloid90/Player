//
//  MTDirectionalTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTDirectionalTransition: BCMTransition {
    
    public var direction: MTIVector = MTIVector(x: 0, y: 1.0)

    override var fragmentName: String {
        return "DirectionalFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": direction
        ]
    }
}
