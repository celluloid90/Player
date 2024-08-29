//
//  AudioManager.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 22/5/23.
//

import UIKit
import AVFoundation

protocol AudioManagerDelegate:NSObject {
    func updatePeriodicAudioTime(time: CMTime) -> Void
    func playerFinishedPlaying() -> Void
}

public class BCMAudioManager: NSObject {
    
    private var queuePlayer : AVQueuePlayer?
    private var looper:AVPlayerLooper?
    
    var audioInfo : BCMAudioInfo!
    weak var delegate: AudioManagerDelegate?
    private var periodicObserver : Any?
    var slideShowDuration:Double = 0
    
    func setAudio(url: URL) -> Void {
        audioInfo = BCMAudioInfo(url: url)
        setUpPlayer(audioInfo: audioInfo)
    }
    
    
    func setUpPlayer(audioInfo: BCMAudioInfo) -> Void {
        removePeriodicObserver()
        if let composition = prepareComposition(audioInfo: audioInfo, isSample: false){
            
            let playerItem = AVPlayerItem(asset: composition)
            
            if let audioMix = prepareAudioMix(composition, audioInfo: audioInfo){
                playerItem.audioMix = audioMix
            }
            
            queuePlayer = AVQueuePlayer(playerItem: playerItem)
            queuePlayer?.volume = audioInfo.audioVolume
            looper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
            
        }
        
    }
    
    func getAudioMix() -> AVAudioMix? {
        return queuePlayer?.currentItem?.audioMix
    }
    
    func getComposition() -> AVMutableComposition? {
        if let composition = queuePlayer?.currentItem?.asset as? AVMutableComposition{
            return composition
        }
        return nil
    }
    
    func setUpSamplePlayer(audioInfo: BCMAudioInfo) -> Void {
        removePeriodicObserver()
        if let composition = prepareComposition(audioInfo: audioInfo,isSample: true){
            
            if let item = queuePlayer?.currentItem{
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            }
            
            let playerItem = AVPlayerItem(asset: composition)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

            queuePlayer = AVQueuePlayer(playerItem: playerItem)
            queuePlayer?.volume = audioInfo.audioVolume
            
            //looper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        }
    }
    
    private func prepareComposition (audioInfo: BCMAudioInfo,isSample:Bool ) -> AVMutableComposition?{
        
        let asset = AVAsset(url: audioInfo.audioURL)
        
        let composition = AVMutableComposition()

        guard let audioTrack = asset.tracks(withMediaType: .audio).first else { return nil}
        
        var totalDuration = slideShowDuration
        
        if isSample {
            totalDuration = audioInfo.duration
        }
        
        repeat {
            
            let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            var timeRange : CMTimeRange = .zero
            
            let reqDuration = totalDuration - composition.duration.seconds
            
            if reqDuration < audioInfo.duration{
                
                let endTime = audioInfo.startTime.seconds + reqDuration
                
                timeRange = CMTimeRange(start: audioInfo.startTime, end: CMTime(seconds: endTime, preferredTimescale: audioInfo.timeScale))

            }else{
                timeRange = CMTimeRange(start: audioInfo.startTime, end: audioInfo.endTime)
            }
            
            do {
                try compositionTrack?.insertTimeRange(timeRange, of: audioTrack, at: composition.duration)
            } catch let error {
                print("can't prepare audio composition \(error.localizedDescription)")
                break
            }
            
        } while composition.duration.seconds < totalDuration
        
        return composition
        
    }
    
    func prepareAudioMix(_ composition: AVMutableComposition,audioInfo: BCMAudioInfo) -> AVMutableAudioMix? {
        
        let assetTracks = composition.tracks(withMediaType: .audio)
        guard assetTracks.count > 0 else { return nil }
        
        let audioMix = AVMutableAudioMix()
        var mixParameters = [AVMutableAudioMixInputParameters]()
        
        var index = 0
        for assetTrack in assetTracks {
            
            let mixParameter = AVMutableAudioMixInputParameters()
            
            mixParameter.setVolume(audioInfo.audioVolume, at: .zero)
            mixParameter.trackID = assetTrack.trackID
                    
            let duration = composition.duration
            
            if audioInfo.fadeIN && index == 0 {
                let startFadeInTime = CMTime.zero
                let endTime = duration.seconds < 10 ? duration.seconds / 4.0 : 5.0
                
                let endFadeInTime = CMTime(seconds:endTime , preferredTimescale: duration.timescale)
                let fadeInTimeRange = CMTimeRange(start: startFadeInTime, end: endFadeInTime)

                mixParameter.setVolumeRamp(fromStartVolume: 0.0, toEndVolume: audioInfo.audioVolume, timeRange: fadeInTimeRange)
            }
            
            if audioInfo.fadeOUT && index == assetTracks.count - 1 {
                
                var fadeDuration = (duration.seconds < 10 ? duration.seconds / 4.0 : 5.0)
                
                if fadeDuration > assetTrack.timeRange.duration.seconds{
                    fadeDuration = assetTrack.timeRange.duration.seconds
                }
                
                let startTime = duration.seconds - fadeDuration
                
                let startFadeOutTime = CMTime(seconds:startTime , preferredTimescale: duration.timescale)
                let fadeOutTimeRange = CMTimeRange(start: startFadeOutTime, end: duration)

                mixParameter.setVolumeRamp(fromStartVolume: audioInfo.audioVolume, toEndVolume: 0.0, timeRange: fadeOutTimeRange)
            }
            
            mixParameters.append(mixParameter)
            index += 1
        }

        audioMix.inputParameters = mixParameters
        
        return audioMix
        
    }
    
    @objc func playerDidFinishPlaying(){
        delegate?.playerFinishedPlaying()
    }
    
    func addPeriodicObserver() -> Void {
        removePeriodicObserver()
        periodicObserver = queuePlayer?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC)), queue: .global(), using: { time in
            self.delegate?.updatePeriodicAudioTime(time: time)
        })
    }
    
    func removePeriodicObserver() -> Void {
        
        if let periodicObserver{
            queuePlayer?.removeTimeObserver(periodicObserver)
            self.periodicObserver = nil
        }
        
    }
    
    func isPlaying() -> Bool {
        return queuePlayer?.timeControlStatus == .playing
    }

    func play() {
        queuePlayer?.play()
    }
    
    func pause() {
        queuePlayer?.pause()
    }
    
    func seekTo(time: CMTime) -> Void {
        
        queuePlayer?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func changeVolume(value: Float) -> Void {
        queuePlayer?.volume = value
    }
    
}
