//
//  APSupport.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

struct Profile {
    var Username: String
    var FullName: String
    var MainTicket: String
    var ProfilePicture: UIImage
    
    init() {
        self.FullName = "Guest";
        self.MainTicket = "NONE";
        self.Username = "Guest";
        self.ProfilePicture = UIImage()
    }
    
    init(fullname: String, username: String, mainticket: String) {
        self.FullName = fullname;
        self.MainTicket = mainticket;
        self.Username = username;
        self.ProfilePicture = UIImage()
    }
    
    
}

struct FAQ_Article {
    var id: Int
    var title: String
    var content: String
}

struct Chat {
    var id: Int
    var message: String
    var username: String
    var datetime: Date
}

struct FAQ_Category {
    var category: [String]
}


let headers: HTTPHeaders = [
    "Accept":"application/json, text/plain, */*",
    "Content-type":"application/x-www-form-urlencoded",
    "Origin":"https://apspace.apu.edu.my",
    "Referer":"https://apspace.apu.edu.my/",
    "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
]

func newAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alert
}
