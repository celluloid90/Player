//
//  SwipeFromMiddleTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit

public class SwipeFromMiddleTransition: BCMTransition {

    public var direction = 0


    override var fragmentName: String {
        return "SwipeFromMiddleTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": direction,

        ]
    }
    
}
