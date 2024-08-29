//
//  MetalPlayer.swift
//  BCMComposition
//
//  Created by BCL Device7 on 20/9/23.
//

import UIKit
import MetalPetal

public enum MetalPlayerStatus {
case playing,notPlaying
}

public class BCMPlayer: UIView {

    private var imageView: MTIImageView!
    private var displayLink: CADisplayLink?
    public var composition : BCMComposition!
    public var status : MetalPlayerStatus = .notPlaying
    
    private var progressObserver: ((_ progress: Float) -> Void)?
    
    public override var frame: CGRect{
        didSet{
            imageView?.frame = CGRect(origin: .zero, size: frame.size)
            
        }
    }
    
    public init(frame: CGRect, composition: BCMComposition) {
        super.init(frame: frame)
        self.composition = composition
        imageView = MTIImageView(frame: CGRect(origin: .zero, size: frame.size))
        self.addSubview(imageView)
        displayLinkSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setComposition(composition: BCMComposition) -> Void {
        self.composition = composition
        updatePreviewFrame()
    }
    
    public func addProgressObserver(_ observer: @escaping (_ progress: Float) -> Void)-> Void {
        self.progressObserver = observer
    }
    
    public func removePeriodicObserver(){
        self.progressObserver = nil
    }
    
    func updatePreviewFrame() -> Void {
        self.imageView.image = self.composition.draw()
        progressObserver?(composition.getVideoProgress())
    }
    
    func displayLinkSetup() -> Void {

        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkHandler))
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 60, __preferred: 30)
        } else {
            displayLink?.preferredFramesPerSecond = 30
        }
        displayLink?.add(to: .main, forMode: .common)
        displayLink?.isPaused = true
    }
    
    @objc func displayLinkHandler() -> Void {
        
        var progress = composition.getVideoProgress()
        
        if progress > 1.0 {
            composition.resetProgress()
            progress = composition.getVideoProgress()
        }
        updatePreviewFrame()
        self.composition.increaseFrameCount()
        
        
    }
    
    public func pause() -> Void {
        status = .notPlaying
        displayLink?.isPaused = true
    }
    
    public func play() -> Void {
        status = .playing
        displayLink?.isPaused = false
    }
    
    public func seekTo(progress: Float) -> Void {
        composition.setDisplayCountByProgress(progress)
        updatePreviewFrame()
    }
    
    public func seekTo(seconds: Float) -> Void {
        composition.setDisplayCountByTime(seconds)
        updatePreviewFrame()
    }
    
    
    
    
    
}
