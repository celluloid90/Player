//
//  HalfDirectionalWipeTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 29/3/23.
//

import Foundation

class HalfDirectionalWipeTransition: BCMTransition {
    var direction = 0
    
    override var fragmentName: String {
        return "HalfDirectionalWipeTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction" : direction,

        ]
    }
}
