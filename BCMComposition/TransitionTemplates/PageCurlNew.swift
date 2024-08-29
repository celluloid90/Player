//
//  PageCurl.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 28/3/23.
//

import UIKit
import MetalPetal

class PageCurlNew: BCMTransitionTemplate {

    let pageCurlTransition = InvertedPageCurlTransition()
    
    override func draw() -> MTIImage? {
        _ = super.draw()
        
        pageCurlTransition.inputImage = source.backgroundImage
        pageCurlTransition.destImage = source.forgroundImage
        
        return pageCurlTransition.outputImage
        
    }
    
    override func updateParams() {
        let time = source.currentProgress
        pageCurlTransition.progress = time
    }
    
}
