//
//  StickerItem.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit

public class BCMStickerItem {
    
    var url:URL?
    
    init(url: URL!) {
        self.url = url
    }
    
    init(name:String) {
        
        
        if let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "jpg") {
            self.url = url
        }else if let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "JPG") {
            self.url = url
        }
        else if let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "PNG") {
            self.url = url
        }else if let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "png") {
            self.url = url
        }
        else if let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "heic") {
            self.url = url
        }
        
    }
    
}
