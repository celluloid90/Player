//
//  AudioInfo.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 17/5/23.
//

import UIKit
import AVFoundation

struct BCMAudioInfo {

    var fadeIN: Bool = true
    var fadeOUT: Bool = true
    var fadeLOOP: Bool = false
    var duration: Double = 0
    var durationOriginal: Double = 0
    var audioURL: URL!
    var audioTitle: String = ""
    var startTime: CMTime = .zero
    var timeScale: CMTimeScale = CMTimeScale(NSEC_PER_SEC)
    var endTime: CMTime = .zero
    var audioVolume: Float = 1
    
    init(url: URL) {
        
        let audioAsset = AVURLAsset(url: url)
        audioURL = url
        durationOriginal = CMTimeGetSeconds(audioAsset.duration)
        duration = durationOriginal
        audioTitle = url.lastPathComponent.components(separatedBy: ".").first?.replacingOccurrences(of: "_", with: " ") ?? ""
        
        startTime = CMTime.zero
        //timeScale = startTime.timescale
        endTime = CMTime(seconds: audioAsset.duration.seconds, preferredTimescale: timeScale)
        
    }
    
    
}
