//
//  BannerZoomTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/3/23.
//

import UIKit

public class BannerZoomTransition: BCMTransition {

    var direction = 0
    var thickness:Float = 0.2
    var zoomFactor:Float = 0.25
    
    override var fragmentName: String {
        return "BannerZoomTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "direction": direction,
            "thickness": thickness,
            "zoomFactor" : zoomFactor
        ]
    }
    
}
