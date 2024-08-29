//
//  BMComposition.swift
//  BMComposition
//
//  Created by BCL Device7 on 18/9/23.
//

import UIKit
import MetalPetal

@objc public protocol BCMCompositionDelegate{
    @objc optional func applyTransition(transition: BCMTransition) -> MTIImage?
}

public class BCMComposition: BCMCompositionSource {
    
    public weak var delegate: BCMCompositionDelegate?
        
    public override init(bcmAssets: [BCMAsset], templateType: BCMTransitionTemplate.Type? = nil) {
        super.init(bcmAssets: bcmAssets, templateType: templateType)
        makeVideoComposition()
    }
    
    public func draw() -> MTIImage? {
        super.draw()
        if let videoTemplate{
            return videoTemplate.draw()?.oriented(.downMirrored)
        }else if let transition{
            transition.inputImage = self.backgroundImage
            transition.destImage = self.forgroundImage
            transition.progress = currentProgress

            return (delegate?.applyTransition?(transition: transition)) ?? transition.outputImage?.oriented(.downMirrored)
            
        }
        return self.forgroundImage
    }
    
    public func getFrames(progresses:[Float])-> [MTIImage]{
        var frames = [MTIImage]()
        for progress in progresses {
            self.setDisplayCountByProgress(progress)
            if let frame = self.draw(){
                frames.append(frame)
            }
        }
        self.setDisplayCountByProgress(0)
        return frames
    }
    
    public func getFrames(seconds:[Float]) -> [MTIImage] {
        var frames = [MTIImage]()
        for sec in seconds {
            self.setDisplayCountByTime(sec)
            if let frame = self.draw(){
                frames.append(frame)
            }
        }
        self.setDisplayCountByTime(0)
        return frames
    }
    
    
    private func makeVideoComposition(){
        
        var insertTime : CMTime = .zero
        
        for i in 0..<bcmAssets.count {
            
            if templateType == nil, let transition = bcmAssets[i].transition, i < bcmAssets.count - 1{
                
                var endTime = bcmAssets[i].duration - CMTime(seconds: transition.duration.seconds / 2, preferredTimescale: bcmAssets[i].duration.timescale)
                
                if i - 1 >= 0, let prevTransition = bcmAssets[i - 1].transition{
                    endTime = endTime - CMTime(seconds: prevTransition.duration.seconds / 2, preferredTimescale: bcmAssets[i - 1].duration.timescale)
                }
                
                // add track instruction
                
                if endTime.seconds > 0 {
                    bcmAssets[i].timeRange = CMTimeRange(start: insertTime, duration: endTime)
                    
                    insertTime = CMTimeAdd(insertTime, endTime)
                }
                
                // add transition instruction
                
                let transTimeRange = CMTimeRange(start: insertTime, duration: transition.duration)
                bcmAssets[i].transition?.timeRange = transTimeRange
                insertTime = CMTimeAdd(insertTime, transition.duration)
                
            }else{
                
                if templateType == nil, i - 1 >= 0, let transition = bcmAssets[i - 1].transition{
                    
                    let endTime = bcmAssets[i].duration - CMTime(seconds: transition.duration.seconds / 2, preferredTimescale: bcmAssets[i].duration.timescale)
                    
                    bcmAssets[i].timeRange = CMTimeRange(start: insertTime, duration: endTime)
                }else{
                    bcmAssets[i].timeRange = CMTimeRange(start: insertTime, duration: bcmAssets[i].duration)
                }
                
                if bcmAssets[i].timeRange.duration.seconds > 0{
                    
                    insertTime = CMTimeAdd(insertTime, bcmAssets[i].duration)
                }
                
            }
            
            bcmAssets[i].order = i
        }
        
    }
    
    
}
