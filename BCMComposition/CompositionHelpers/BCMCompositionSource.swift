//
//  MetalCompositionSource.swift
//  BCMTransitions
//
//  Created by BCL Device7 on 18/9/23.
//

import UIKit
import CoreMedia.CMTime
import MetalPetal

public class BCMCompositionSource: NSObject {
    
    static let DEFAULT_FRAME_RATE = 30
    
    var duration: Float = 0
    
    private var frameCount = 0
    private var maxFrameCount = 0
    private var framePerSecond = DEFAULT_FRAME_RATE
    private var currentSpeed: Float = 1
    public var currentAssetIndex = -1

    public var currentProgress:Float = 0
    public var currentAssetProgress:Float = 0

    var transition : BCMTransition?
    
    var bcmAssets: [BCMAsset] = [BCMAsset]()
    
    public var renderSize: CGSize = CGSize(width: 1080, height: 1080){
        didSet{
            //TODO:
        }
    }
    
    public var sliderValueChanging = false{
        didSet{
            compositionFrameProducer?.sliderValueChanging = sliderValueChanging
        }
        
    }
    
    var forgroundImage : MTIImage!{
        get{
            if templateType != nil{
                return templateFrameProducer?.forgroundImage
            }else{
                return compositionFrameProducer?.foregroundImage
            }
        }
    }
    var backgroundImage : MTIImage!{
        get{
            if templateType != nil{
                return templateFrameProducer?.backgroundImage
            }else{
                return compositionFrameProducer?.backgroundImage
            }
        }
    }
    
    var compositionFrameProducer: BCMCompositionFrameProducer?
    
    var templateFrameProducer : BCMCompositionTemplateFrameProducer?
    
    var templateType: BCMTransitionTemplate.Type?
    var videoTemplate: BCMTransitionTemplate?
    
    public init(bcmAssets: [BCMAsset], templateType: BCMTransitionTemplate.Type? = nil) {
        super.init()
        self.bcmAssets = bcmAssets
        
        if templateType != nil{
            templateFrameProducer = BCMCompositionTemplateFrameProducer(bcmAssets: bcmAssets)
            self.templateType = templateType
            videoTemplate = templateType?.init(source: self)
        }else{
            compositionFrameProducer = BCMCompositionFrameProducer(bcmAssets: bcmAssets)
        }
        
        calculateTime()
    }
    
    public func calculateTime() -> Void {
        duration = 0
        for asset in bcmAssets {
            duration += Float(asset.duration.seconds)
        }
        
        setSpeed(value: currentSpeed)
    }
    
    public func setSpeed(value:Float) -> Void {
        currentSpeed = value
        duration = 0
        
        for asset in bcmAssets {
            duration += Float(asset.duration.seconds)
        }
        
        duration /= value
        maxFrameCount = Int(duration * Float(framePerSecond))
    }
    
    public func getSpeed() -> Float {
        return currentSpeed
    }
    
    public func setFrameRate(value:Int) -> Void {
        self.framePerSecond = value
        
        for asset in bcmAssets {
            duration += Float(asset.duration.seconds)
        }
        
        duration /= getSpeed()
        maxFrameCount = Int(duration * Float(framePerSecond))
    }
    
    public func getFrameRate() -> Int {
        return Int(framePerSecond)
    }
    
    public func getDuration() -> Float {
        return duration
    }
    public func getProgressTime() -> Float {
        let progress = getVideoProgress()
        return duration * progress
    }
    
    public func increaseFrameCount() -> Void {
        self.frameCount += 1
    }
    
    public func decreaseFrameCount() -> Void {
        self.frameCount -= 1
        if self.frameCount < 0 {
            resetProgress()
        }
    }
    
    public func setDisplayCountByProgress(_ value:Float) -> Void {
        if value < 0 || value > 1 {
            return
        }
        self.frameCount = Int(Float(maxFrameCount) * value)
        print("slider value \(value) displaycount \(frameCount)")
    }
    
    func setDisplayCountByTime(_ time: Float) -> Void {
        if time < 0 || time > duration {
            return
        }
        let progress = time / duration
        setDisplayCountByProgress(progress)
    }
    
    public func resetProgress() -> Void {
        print("############# slide show reset ###############")
        self.frameCount = 0
    }
    
    public func getVideoProgress() -> Float {
        return Float(frameCount) / Float(maxFrameCount)
    }
    
    private func applyProgress(progress: Float){
        
        var assetIndex = -1
        let time = CMTime(seconds: Double(duration * progress), preferredTimescale: 600)
        
        if let index = bcmAssets.firstIndex(where: {$0.timeRange.containsTime(time) || $0.timeRange.end == time }){
            
            assetIndex = index
            if transition != nil{
                compositionFrameProducer?.changeSlide(drawFrag: index, transitioning: false)
                transition = nil
            }
            let diff = time - bcmAssets[assetIndex].timeRange.start
            currentProgress = Float(diff.seconds / bcmAssets[assetIndex].timeRange.duration.seconds)
            
        }else if let index = bcmAssets.firstIndex(where: {($0.transition?.timeRange.containsTime(time) ?? false) || ($0.transition?.timeRange.end == time)}),
            let assetTransition = bcmAssets[index].transition
        {
            
            if transition == nil || transition?.isKind(of: assetTransition.type) == false {
                transition = assetTransition.type.init()
                compositionFrameProducer?.changeSlide(drawFrag: index, transitioning: transition != nil)
            }

            let diff = time - assetTransition.timeRange.start
            currentProgress = Float(diff.seconds / assetTransition.timeRange.duration.seconds)

            assetIndex = index
            
        }else{
            fatalError("Empty time space in composition track")
        }

        if(assetIndex != currentAssetIndex){
            currentAssetIndex = assetIndex
            templateFrameProducer?.changeSlide(drawFrag: assetIndex)
            compositionFrameProducer?.changeSlide(drawFrag: assetIndex, transitioning: transition != nil)

        }

        var assetTimeRange = CMTimeRange(start: bcmAssets[assetIndex].timeRange.start, duration: bcmAssets[assetIndex].duration)
        var diff = time - assetTimeRange.start
        if diff > assetTimeRange.duration{
            let startTime = CMTime(seconds: bcmAssets[assetIndex + 1].timeRange.start.seconds - (bcmAssets[assetIndex].transition?.timeRange.duration.seconds ?? 0) / 2, preferredTimescale: 600)
            assetTimeRange = CMTimeRange(start: startTime, duration: bcmAssets[assetIndex + 1].duration)
            diff = time - assetTimeRange.start
        }
        currentAssetProgress = Float(diff.seconds / assetTimeRange.duration.seconds)
        
        print("currentProgress \(currentProgress) \(transition == nil ? "Passthrough" : "transitioning")")
        print("currentAssetProgress \(currentAssetProgress)")
        
    }
    
    func clear() {
        currentAssetIndex = -1
        resetProgress()
    }
    
    public func draw() {
        
        if bcmAssets.count == 0{
            return
        }
        applyProgress(progress: getVideoProgress())
        
        templateFrameProducer?.draw(progress: currentAssetProgress)
        compositionFrameProducer?.draw(progress: currentAssetProgress)

    }
    

    public func getDrawFrag()->Int {return currentAssetIndex}
    public func getSingleSlideProgress()->Float {return currentProgress}
    
}
