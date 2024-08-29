//
//  BCMAsset.swift
//  BCMTransitions
//
//  Created by BCL Device7 on 9/8/23.
//

import Foundation
import Photos
import MetalPetal
import AVFoundation

public struct BCMAssetTransition{
    var duration: CMTime = .zero
    var type : BCMTransition.Type
    var timeRange: CMTimeRange = .zero // in output video
    
    public init(duration: Double, transType: BCMTransition.Type) {
        self.duration = CMTime(seconds: duration, preferredTimescale: 600)
        self.type = transType
    }
}

public enum BCMAssetType{
    case Image, Video, Audio, Layer, Transition
}

public class BCMAsset: Equatable {
    
    var type: BCMAssetType

    var originalDuration: CMTime = .zero // original

    var duration: CMTime = .zero // trim
    public var startTime: CMTime  = CMTime.zero // trim
    public var endTime: CMTime = CMTime.zero // trim
    var timeRange: CMTimeRange = .zero // in output video
    var url: URL!
    public var order: Int = -1
    public var transition: BCMAssetTransition?
    
    var mtiImage : MTIImage?
    
    var originalImage : MTIImage?{
        
        if type == .Image {
            if let image = UIImage(contentsOfFile: self.url.path){
                return MTIImage(image: image).unpremultiplyingAlpha()
            }
        }
        return nil
    }
    
    var avAsset: AVAsset{
        return AVAsset(url: self.url)
    }
    
    public init(url: URL,type: BCMAssetType) {
        self.url = url
        self.type = type
        self.startTime = CMTime.zero
        
        if type == .Image {
            self.duration = CMTime(seconds: 3, preferredTimescale: 600)
            mtiImage = originalImage?.centerCropped(CGSize(width: 1080, height: 1080))
        }else{
            self.originalDuration = avAsset.duration
            self.duration = self.originalDuration
        }
        
        self.endTime = self.duration
        
    }
    
    public func setDuration(_ value: Float ) -> Void {
        if self.type == .Image{
            self.duration = CMTime(seconds: Double(value), preferredTimescale: 600)
            self.endTime = self.duration
        }
    }
    
    public static func == (lhs: BCMAsset, rhs: BCMAsset) -> Bool {
        var isEqual = lhs.timeRange == rhs.timeRange
        isEqual = isEqual && lhs.type == rhs.type
        isEqual = isEqual && lhs.duration == rhs.duration
        isEqual = isEqual && lhs.url == rhs.url
        isEqual = isEqual && lhs.order == rhs.order

        return isEqual
    }
    
}
