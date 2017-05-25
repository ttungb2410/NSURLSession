//
//  CellLabel.swift
//  NSURLSession
//
//  Created by Thanh Tung on 6/20/17.
//  Copyright © 2017 Thanh Tung. All rights reserved.
//

import UIKit

class CellLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if tag == 101 {
            configure(UIColor.init(red: 244/255, green: 117/255, blue: 100/255, alpha: 1.0), fontName: "OpenSans-Semibold", fontSize: 20.0)
        }else{
            configure(UIColor.gray, fontName: "OpenSans-Light", fontSize: 12.0)
        }
        
    }
    
    func configure(_ color : UIColor, fontName : String, fontSize : CGFloat) {
        textColor = color
        font = UIFont(name: fontName, size: fontSize)
    }
}
