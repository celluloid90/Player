//
//  BCMExporter.swift
//  BCMTransitions
//
//  Created by BCL Device7 on 14/9/23.
//

import UIKit
import AVFoundation

class BCMExporterOld: NSObject {

    
    func saveToDirectory(){
        
        guard let composition = self.playerItem.asset as? AVComposition else {
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath =           documentsDirectory.appendingPathComponent("renderedVideo.mp4")

        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try    FileManager.default.removeItem(atPath: filePath.path) }
            catch {fatalError("Unable to delete file: \(error) : \(#function).")}
        }

        if let exportSession = AVAssetExportSession(asset: composition , presetName: AVAssetExportPresetHighestQuality){

            exportSession.videoComposition = self.playerItem.videoComposition

            //  exportSession.canPerformMultiplePassesOverSourceMediaData = true
            exportSession.outputURL = filePath
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.timeRange = CMTimeRange(start: .zero, end: self.playerItem.asset.duration)
            exportSession.outputFileType = .mp4

            exportSession.exportAsynchronously {
                print("finished: \(filePath) :  \(exportSession.status.rawValue) ")
                if exportSession.status == .completed {

                    if let url = exportSession.outputURL{
                        self.exportToPhotoLibrary(url: url)
                    }

                }else if exportSession.status == .failed {
                    self.queuePlayer.play()
                    print("Export failed -> Reason: \(exportSession.error!.localizedDescription))")
                    print(exportSession.error!)

                }

            }

        }

    }
    
}
