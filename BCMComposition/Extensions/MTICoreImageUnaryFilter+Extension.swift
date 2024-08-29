//
//  MTICoreImageUnaryFilter+Extension.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 25/4/23.
//

import Foundation
import MetalPetal

extension MTICoreImageUnaryFilter{
    
    convenience init(effect: BCMCIEffect) {
        self.init()
        
        guard let filterName = effect.filterName, filterName.isEmpty == false else {
            assert(false,"Core Image Filter name can't be nil or empty")
            return
        }

        
        self.filter = CIFilter(name: filterName)
        
        if let intensity = effect.inputIntensity {
            self.filter?.setValue(NSNumber(value: intensity), forKey: kCIInputIntensityKey)
        }
        
        if let radius = effect.inputRadius {
            self.filter?.setValue(NSNumber(value: radius), forKey: kCIInputRadiusKey)
        }
        
        if let angle = effect.inputAngle {
            self.filter?.setValue(NSNumber(value: angle), forKey: kCIInputAngleKey)
        }
        
        if let ev = effect.inputEV {
            self.filter?.setValue(NSNumber(value: ev), forKey: kCIInputEVKey)
        }
        
        if let level = effect.inputLevels {
            self.filter?.setValue(NSNumber(value: level), forKey: "inputLevels")
        }
        
        if let power = effect.inputPower {
            self.filter?.setValue(NSNumber(value: power), forKey: "inputPower")
        }
        
        
        
        if let color = effect.inputColor {
            
            self.filter?.setValue(CIColor(red: CGFloat(color[0]) / 255, green: CGFloat(color[1]) / 255, blue: CGFloat(color[2]) / 255), forKey: kCIInputColorKey)
        }
        
        if let center = effect.inputCenter{
            self.filter?.setValue(center, forKey: kCIInputCenterKey)
        }
        
        if let time = effect.inputTime {
            self.filter?.setValue(NSNumber(value: time), forKey: kCIInputTimeKey)
        }
        
        if let scale = effect.inputScale {
            self.filter?.setValue(NSNumber(value: scale), forKey: kCIInputScaleKey)
        }
        
        if let width = effect.inputWidth {
            self.filter?.setValue(NSNumber(value: width), forKey: kCIInputWidthKey)
        }
        
        if let height = effect.inputBottomHeight{
            self.filter?.setValue(NSNumber(value: height), forKey: "inputBottomHeight")
        }
        
        if let shadow = effect.inputFoldShadowAmount{
            self.filter?.setValue(NSNumber(value: shadow), forKey: "inputFoldShadowAmount")
        }
        
        if let folds = effect.inputNumberOfFolds{
            self.filter?.setValue(NSNumber(value: folds), forKey: "inputNumberOfFolds")
        }
        
    }
    
    func setInputTime (_ time : Float ){
        self.filter?.setValue(NSNumber(value: time), forKey: kCIInputTimeKey)
    }
    
    func setTargetImage(_ ciimage: CIImage) -> Void {
        self.filter?.setValue(ciimage, forKey: kCIInputTargetImageKey)
    }
    
    func setCenter(_ center: CIVector) -> Void {
        self.filter?.setValue(center, forKey: kCIInputCenterKey)
    }

}
