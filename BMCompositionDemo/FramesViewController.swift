//
//  FramesViewController.swift
//  BCMComposition
//
//  Created by BCL Device7 on 1/10/23.
//

import UIKit
import BCMComposition

class FramesViewController: UIViewController {

    @IBOutlet weak var frameCollectionView: UICollectionView!
    var composition:BCMComposition!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension FramesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameCollectionCell", for: indexPath) as? FrameCollectionCell
        cell?.iconView.image = composition.getFrames(progresses: [Float(indexPath.row) / 10]).first
        return cell!
    }
    
    
}
