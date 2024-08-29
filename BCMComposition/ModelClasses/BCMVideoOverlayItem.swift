//
//  VideoOverlayItem.swift
//  SlideShowMaker
//
//  Created by BCL Device7 on 7/12/22.
//

import UIKit

enum BCMVideoOverlays : String {
    
    case old_tv_small
    case polka_dot
    case light_leak_tgt
    case light_leak
    case color_line
    case water_splash
    case color_paper
    case Fire_Embers
    case holiday
    case SampleVideo_1280x720_10mb
    case brush_1_1
    case brush_1_2
    case brush_1_3
    
    static func item(_ type:BCMVideoOverlays) -> BCMVideoOverlayItem{
        
        return BCMVideoOverlayItem(name: type.rawValue)
        
    }
    
}

class BCMVideoOverlayItem: BCMVideoItem {
    
}
