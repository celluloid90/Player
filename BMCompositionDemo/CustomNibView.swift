//
//  CustomXibView.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 5/4/23.
//

import UIKit

class CustomNibView: UIView {

    @IBOutlet weak var contentView:UIView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    func customInit() -> Void {
        Bundle.main.loadNibNamed(nibName(), owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]

        self.addSubview(self.contentView)
       // self.sendSubviewToBack(self.contentView)
        
    }
    
    func nibName() -> String {
        //must voverride this method to load your view

        return ""
    }

}
