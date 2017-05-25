//
//  CustomTextField.swift
//  NSURLSession
//
//  Created by Thanh Tung on 6/20/17.
//  Copyright © 2017 Thanh Tung. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = UIFont.init(name: "OpenSans-Light", size: 18.0)
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 248/255, green: 116/255, blue: 98/255, alpha: 1.0).cgColor
        switch tag {
        case 101:
            configurePlaceholder("Name")
        case 102:
            configurePlaceholder("Phone Number")
        case 103:
            configurePlaceholder("City")
        case 104:
            configurePlaceholder("Email")
        default:
            break
        }
        
        
    }
    
    func configurePlaceholder(_ content : String) {
        let attribute = [NSFontAttributeName : UIFont.init(name: "OpenSans-Light", size: 18.0)!, NSForegroundColorAttributeName : UIColor.black]
        
        attributedPlaceholder = NSAttributedString(string: content, attributes: attribute)
    }

}
