//
//  StickerItem.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 18/7/23.
//

import UIKit
import MetalPetal

public class BCMOverlayItem {
    
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
    
    var mtiImage : MTIImage {
        if let url = self.url, let image = UIImage(contentsOfFile: url.path){
            return MTIImage(image: image).premultiplyingAlpha()
        }else{
            return MTIImage(color: MTIColor(), sRGB: false, size: CGSize(width: 100, height: 100))
        }
    }
    
}
