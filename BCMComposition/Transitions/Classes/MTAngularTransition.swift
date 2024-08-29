//
//  MTAngularTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

import MetalPetal

public class MTAngularTransition: BCMTransition {
    
    public var startingAngle: Float = 0
    public var center = MTIVector(x: 0.5, y: 0.5)
    public var direction = 0
    public var isTwoDirectional = 0
    
    override var fragmentName: String {
        return "AngularFragment"
    }

    override var parameters: [String: Any] {
        return [
            "startingAngle": startingAngle,
            "center" : center,
            "direction": direction,
            "isTwoDirectional" : isTwoDirectional
        ]
    }
}
