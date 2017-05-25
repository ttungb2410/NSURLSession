//
//  Persion.swift
//  NSURLSession
//
//  Created by Thanh Tung on 6/20/17.
//  Copyright © 2017 Thanh Tung. All rights reserved.
//

import UIKit

class Person: NSObject {

    var id: String?
    var name: String?
    var phoneNumber: Int?
    var email: String?
    var city: String?

    init(information: [String : AnyObject?]) {
        
        let id = information["id"] as? String
        self.id = id
        let name = information["Name"] as? String
        self.name = name
        let phoneNumber = information["PhoneNumber"] as? Int
        self.phoneNumber  = phoneNumber
        let email = information["Email"] as? String
        self.email = email
        let city = information["City"] as? String
        self.city = city
    }
}
