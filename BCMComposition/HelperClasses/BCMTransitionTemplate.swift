//
//  BCMTransitionTemplate.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 14/3/23.
//

import UIKit
import MetalPetal

public class BCMTransitionTemplate: NSObject {
    
    var renderSize = CGSize.zero 
    var sliderValueChanging = false
    var source : BCMCompositionSource!
    
    var videoItems = [BCMVideoItem]()
    var currentAssetIndex = 0
    lazy var mtiContext: MTIContext? = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    required public init(source: BCMCompositionSource) {
        self.source = source
    }

    public func setSource (source: BCMCompositionSource){
        self.source = source
    }
    
    public func setup() -> Void {
        
    }
    
    public func draw() -> MTIImage? {
        updateParams()
        //print("Template slide P: \(source.currentAssetProgress) total P : \(source.getProgress()) ")
        return nil
    }
    
    func updateParams() -> Void {
        
    }
    
    public func speedValueChanged() -> Void {
        
    }
    
    public func templateReStarted() -> Void {
        
    }
    
}
