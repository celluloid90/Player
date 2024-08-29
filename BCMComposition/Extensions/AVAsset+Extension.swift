//
//  AVAsset+Extension.swift
//  BCMTransitions
//
//  Created by BCL Device7 on 10/9/23.
//

import Foundation
import AVFoundation
import MetalPetal

extension AVAsset{
    func generateThumbnail(time: CMTime, size: CGSize, completion: @escaping (MTIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            imageGenerator.maximumSize = size
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(MTIImage(cgImage: image).unpremultiplyingAlpha())
                } else {
                    completion(nil)
                }
            })
        }
    }
}
