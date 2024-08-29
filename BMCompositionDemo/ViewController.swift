//
//  ViewController.swift
//  BMCompositionDemo
//
//  Created by BCL Device7 on 18/9/23.
//

import UIKit
import MetalPetal
import BCMComposition
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressView: ProgressView!

    var allAssets = [BCMAsset]()
    var displayLink: CADisplayLink!
    var composition : BCMComposition!
    var metalPlayer : BCMPlayer!
    var exporter : BCMExporter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.hide()
        let assetUrls = loadImageUrls(names: ["5","9","7","0","6"])
        
        for i in 0..<assetUrls.count {
            
            let url = assetUrls[i]
            
            var asset : BCMAsset!
            if url.pathExtension == "JPG" || url.pathExtension == "jpg" {
                asset  = BCMAsset(url: url, type: .Image)
                asset.setDuration(3)
            }else{
                asset  = BCMAsset(url: url, type: .Video)
            }
            asset.transition = BCMAssetTransition(duration: 2, transType: SwipeFromMiddleTransition.self)
            allAssets.append(asset)
            
        }
        
        composition = BCMComposition(bcmAssets: allAssets,templateType: Soul.self)
        metalPlayer = BCMPlayer(frame: preview.bounds, composition: composition)
        self.preview.addSubview(metalPlayer)
        
        metalPlayer.addProgressObserver { progress in
            
            DispatchQueue.main.async {
                self.slider.setValue(progress, animated: false)
            }
            
        }
        
        metalPlayer.play()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        metalPlayer.frame = preview.bounds
    }
    
    func loadImageUrls(names: [String]) -> [URL] {
        
        var imageUrls = [URL]()
        
        for i in names{
            if let url = Bundle.main.url(forResource: i, withExtension: "JPG"){
                imageUrls.append(url)
            }else if let url = Bundle.main.url(forResource: i, withExtension: "jpg"){
                imageUrls.append(url)
            }else if let url = Bundle.main.url(forResource: i, withExtension: "mp4"){
                imageUrls.append(url)
            }else if let url = Bundle.main.url(forResource: i, withExtension: "MOV"){
                imageUrls.append(url)
            }
        }
        
        return imageUrls
        
    }
    
    @IBAction func framesButtonPressed(_ sender: UIButton){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FramesViewController") as? FramesViewController{
            vc.composition = self.metalPlayer.composition
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func sliderValueChnaged(_ sender: UISlider, _ event: UIEvent ) -> Void {
        
        guard let touchEvent = event.allTouches?.first else {
            return
        }
        
        switch touchEvent.phase {
        case .began:
            metalPlayer.pause()
            metalPlayer.composition.sliderValueChanging = true
            
            break
        case .moved:
            metalPlayer.seekTo(progress: sender.value)
            break
        case .ended,.cancelled:
            metalPlayer.composition.sliderValueChanging = false
            metalPlayer.play()
            break
        default:
            break
        }
        
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton){
        composition.resetProgress()
    }
    
    @IBAction func templateButtonPressed(_ sender: UIButton)
    {
        
        composition = BCMComposition(bcmAssets: allAssets,templateType: Cheerful.self)
        self.metalPlayer.setComposition(composition: composition)
    }
    
    @IBAction func transitionButtonPressed(_ sender: UIButton)
    {
        
        for i in 0..<allAssets.count {
            allAssets[i].transition = BCMAssetTransition(duration: 2, transType: SwipeFromMiddleTransition.self)
        }
        composition = BCMComposition(bcmAssets: allAssets)
        self.metalPlayer.setComposition(composition: composition)
    }
    
    @IBAction func exportButtonPressed(_ sender: UIButton){
    
        if exporter == nil{
            composition.renderSize = BCMExporter.makeExportableSize(size: composition.renderSize)
            exporter = BCMExporter(composition: composition)
            exporter?.delegate = self
        }
        
        guard let documentDirectory = getDocumentUrl() else { return }
        
        let fileName = "slideShow.mp4"
        let path = documentDirectory.appendingPathComponent(fileName).path
        let tempURL = URL(fileURLWithPath: path)
        
        if FileManager.default.fileExists(atPath: tempURL.path){
            try? FileManager.default.removeItem(at: tempURL)
        }
        self.metalPlayer.pause()
        progressView.showPercentage()
        self.exporter?.export(withAudio: false, outputUrl: tempURL, completion: {[weak self] result in
            
            self?.metalPlayer.play()
            switch result {
            case .success(let url):
                if let url{
                    self?.exportToPhotoLibrary(url: url)
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.progressView.hide()
                }
                break
            case .none:
                break
            }
            
        })
    
    }
    
    func exportToPhotoLibrary(url:URL) -> Void {
        PHPhotoLibrary.requestAuthorization {[weak self] auth in
            switch auth {
            case .authorized:
                PHPhotoLibrary.shared().performChanges {
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    let request = PHAssetCreationRequest.forAsset()
                    
                    request.addResource(with: .video, fileURL: url, options: options)
                } completionHandler: {[weak self] success, error in
                    
                    DispatchQueue.main.async {
                        self?.progressView.hide()
                    }
                    
                    DispatchQueue.main.async {
                        if FileManager.default.fileExists(atPath: url.path) {
                            //try? FileManager.default.removeItem(at: url)
                        }
                        var msg = "Can't Save The Video."
                        if success && error == nil {
                            msg = "Video Saved To Gallery"
                        }
                        
                        let alert = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                            
                        }))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
                
                break;
            default:
                print("PhotoLibrary not authorized")
                
                break;
            }
        }
    }
    
    func askPermission(isPermitted: @escaping (_ isPermitted: Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                isPermitted(true)
            case .restricted:
                isPermitted(false)
            case .denied:
                isPermitted(false)
            default:
                break
            }
        }
    }
    
    func getDocumentUrl() -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        return documentsDirectory
    }

    func generateDocumentUrl(fileName: String) -> URL? {
        
        guard let documentsDirectory = getDocumentUrl() else {return nil}
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
}

extension ViewController: BCMExporterDelegate{
    func updateProgress(value: Float) {
        self.progressView.setProgressValue(value: value * 100)
    }
    
    
}
