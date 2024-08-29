//
//  MTIImage+Extension.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 30/5/23.
//

import Foundation
import MetalPetal

extension MTIImage{
    
    convenience init(sticker: BCMOverlayItem) {

        if let url = sticker.url, let image = UIImage(contentsOfFile: url.path){
            self.init(image: image)
        }else{
            self.init(color: MTIColor(), sRGB: false, size: CGSize(width: 100, height: 100))
        }
        
    }
    
    func centerCropped(_ target: CGSize) -> MTIImage? {
        guard let image = self.resized(to: target,resizingMode: .aspectFill) else {
            return nil
        }
        
        let X = image.extent.width/2.0 - target.width/2.0;
        let Y = image.extent.height/2.0 - target.height/2.0;
        
        let  cropRect = CGRect(origin: CGPoint(x: X, y: Y), size: target)
        
        let region = MTICropRegion(bounds: cropRect, unit: .pixel)
        
        return image.cropped(to: region)
        
    }
    
    func croppedIn(size:CGSize) -> MTIImage? {
        
        var newCropWidth:CGFloat, newCropHeight:CGFloat = 0
        let imageSize = self.size
        
        if(imageSize.width < imageSize.height){
            if (imageSize.width < size.width) {
                newCropWidth = size.width;
            }
            else {
                newCropWidth = imageSize.width;
            }
            newCropHeight = (newCropWidth * size.height)/size.width;
        } else {
            if (imageSize.height < size.height) {
                newCropHeight = size.height;
            }
            else {
                newCropHeight = imageSize.height;
            }
            newCropWidth = (newCropHeight * size.width)/size.height;
        }
        
        let X = imageSize.width/2.0 - newCropWidth/2.0;
        let Y = imageSize.height/2.0 - newCropHeight/2.0;
        
        let  cropRect = CGRect(origin: CGPoint(x: X, y: Y), size: CGSize(width: newCropWidth, height: newCropHeight))
        
        let region = MTICropRegion(bounds: cropRect, unit: .pixel)
        return self.cropped(to: region)
    }
    
    func flipImage() -> MTIImage? {

        var transform = CGAffineTransform(scaleX: -1, y: 1)
        transform = transform.concatenating(CGAffineTransform(translationX: -self.size.width, y: 0))
        return self.applyingAssetTrackTransform(transform)
        
    }
    
    func rotateImage(angle: CGFloat) -> MTIImage? {
        let transform = CGAffineTransformMakeRotation(angle * CGFloat.pi / 180)
        return self.applyingAssetTrackTransform(transform)
        
    }
    
    func applyEffect(effect: BCMCIEffect) -> MTIImage? {
        
        if  let filterName = effect.filterName, filterName.isEmpty == false {
            
            let ciUnaryKernel = MTICoreImageUnaryFilter(effect: effect)
            ciUnaryKernel.inputImage = self
            return ciUnaryKernel.outputImage

        }
        return nil
    }
}
