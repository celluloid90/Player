//
//  Video.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 11/4/23.
//

import UIKit

public class BCMVideoItem{
    
    var url:URL!
    
    init(url: URL!) {
        self.url = url
    }
    
    init(name:String) {
        
        var url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "mp4")
        
        if url == nil{
            url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "mov")
        }
        
        self.url = url

    }
    
}
