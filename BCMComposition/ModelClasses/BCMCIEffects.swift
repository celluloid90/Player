//
//  Effects.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 17/4/23.
//

import Foundation
import MetalPetal
import CoreImage.CIFilterBuiltins

public struct BCMCIEffect : Equatable {
    
    public var imageName:String!
    public var name : String!
    public var filterName : String?
    public var filterClass: String?
    public var inputIntensity:Float?
    public var inputRadius:Float?
    public var inputColor : [Int]?
    public var inputEV: Float?
    public var inputPower: Float?
    public var inputAngle: Float?
    public var inputLevels: Float?
    public var inputCenter: CIVector?
    public var inputTime: Float?
    public var inputWidth : Float?
    public var inputScale : Float?
    public var inputBottomHeight: Float?
    public var inputFoldShadowAmount: Float?
    public var inputNumberOfFolds: Float?
    public var inputShadowDensity: Float?
    public var inputShadowRadius:Float?
    
    public init() {
        
    }
}

public struct BCMCIEffects {
    
    public static var pList : [BCMCIEffect] = {
        
        var effects = [BCMCIEffect]()
        
        guard let path = Bundle.main.path(forResource: "FilterList", ofType: "plist") else {
            return effects
        }
        
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:Any]] else {
            return effects
        }

        plist.forEach { item in
            
            var effect = BCMCIEffect()

            
            if let imageName = item["ImageName"] as? String{
                effect.imageName = imageName
            }
            
            if let name = item["name"] as? String{
                effect.name = name
            }
            
            if let filter = item["filter"] as? String{
                effect.filterName = filter
            }
            
            if let color = item["color"] as? String{
                let colors = color.components(separatedBy: ",")
                var colorInt = [Int]()
                colors.forEach { item in
                    colorInt.append(Int(item) ?? 0)
                }
                effect.inputColor = colorInt
            }

            
            if let inputIntensity = item["inputIntensity"] as? String{
                effect.inputIntensity = Float(inputIntensity)
            }
            
            if let radius = item["inputRadius"] as? String{
                effect.inputRadius = Float(radius)
            }
            
            if let ev = item["inputEV"] as? String{
                effect.inputEV = Float(ev)
            }
            
            if let level = item["inputLevels"] as? String{
                effect.inputLevels = Float(level)
            }
            
            
            if let power = item["inputPower"] as? String{
                effect.inputPower = Float(power)
            }
            
            if let angle = item["inputAngle"] as? String{
                effect.inputAngle = Float(angle)
            }
            
            if let center = item["inputCenter"] as? String{
                let centers = center.components(separatedBy: ",")
                
                if centers.count > 1, let x = Float(centers[0]), let y = Float(centers[1]){
                    effect.inputCenter = CIVector(x: CGFloat(x), y: CGFloat(y))
                }
                
            }
            
            if let time = item["inputTime"] as? String{
                effect.inputTime = Float(time)
            }
            
            if let scale = item["inputScale"] as? String{
                effect.inputScale = Float(scale)
            }
            
            if let width = item["inputWidth"] as? String{
                effect.inputWidth = Float(width)
            }
            
            if let bottomHeight = item["inputBottomHeight"] as? String{
                effect.inputBottomHeight = Float(bottomHeight)
            }
            if let shadow = item["inputFoldShadowAmount"] as? String{
                effect.inputFoldShadowAmount = Float(shadow)
            }
            if let folds = item["inputNumberOfFolds"] as? String{
                effect.inputNumberOfFolds = Float(folds)
            }
            
            if let value = item["inputShadowDensity"] as? String{
                effect.inputShadowDensity = Float(value)
            }
            
            if let value = item["inputShadowRadius"] as? String{
                effect.inputShadowRadius = Float(value)
            }
            
            effects.append(effect)
            
        }
        
        return effects
        
        
    }()
    
}

