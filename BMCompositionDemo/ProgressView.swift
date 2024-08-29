//
//  ProgressView.swift
//  SlideShowMaker
//
//  Created by Arifur Rahman on 18/12/22.
//

import UIKit

class ProgressView: CustomNibView {

    @IBOutlet weak var msgLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!

    @IBOutlet weak var indicator:UIActivityIndicatorView!

    
    override func nibName() -> String {
        return "ProgressView"
    }
    
    override func customInit() {
        super.customInit()
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    

    
    func showPercentage() -> Void {
        show()
        if self.indicator.isAnimating{
            self.indicator.stopAnimating()
        }
        self.indicator.isHidden = true
        self.valueLabel.isHidden = false
        
    }
    
    func showIndicator() -> Void {
        show()
        self.valueLabel.isHidden = true
        self.indicator.isHidden = false
    }
    
    func setMsg(msg:String) -> Void {
        msgLabel.text = msg
    }
    
    func setProgressValue(value: Float) -> Void {
        self.valueLabel.text = String(format: "%.0f %%", value)
    }
    
    func hide() -> Void {
        window?.isUserInteractionEnabled = true
        self.isHidden = true
        indicator.stopAnimating()
    }
    
    func show() -> Void {
        window?.isUserInteractionEnabled = false
        self.isHidden = false
        indicator.startAnimating()
    }
    
}
