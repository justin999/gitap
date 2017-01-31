//
//  PlaceHolderTextView.swift
//  gitap
//
//  Created by Koichi Sato on 1/31/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

public class PlaceHolderTextView: UITextView {

    lazy var placeHolderLabel: UILabel = UILabel()
    var placeHolderColor: UIColor      = UIColor.placeHolderGrayColor()
    var placeHolder: String            = ""
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceHolderTextView.textChanged(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    override public func draw(_ rect: CGRect) {
        if self.placeHolder.characters.count > 0 {
            self.placeHolderLabel.frame             = CGRect(x: 8, y: 8, width: self.width - 16, height: 0)
            self.placeHolderLabel.lineBreakMode     = NSLineBreakMode.byWordWrapping
            self.placeHolderLabel.numberOfLines     = 0
            self.placeHolderLabel.font              = self.font
            self.placeHolderLabel.backgroundColor   = UIColor.clear
            self.placeHolderLabel.textColor         = self.placeHolderColor
            self.placeHolderLabel.alpha             = 0.0
            
            self.placeHolderLabel.text = self.placeHolder
            self.placeHolderLabel.sizeToFit()
            self.addSubview(placeHolderLabel)
        }
        
        self.sendSubview(toBack: placeHolderLabel)
        
        if self.text.utf8.count == 0 && self.placeHolder.characters.count > 0 {
            self.placeHolderLabel.alpha = 1.0
        }
        
        super.draw(rect)
    }
    
    @objc private func textChanged(notification: Notification?) {
        if self.placeHolder.characters.count == 0 {
            return
        }
        
        if self.text.utf8.count == 0 {
            self.placeHolderLabel.alpha = 1.0
        } else {
            self.placeHolderLabel.alpha = 0.0
        }
    }
    
}
