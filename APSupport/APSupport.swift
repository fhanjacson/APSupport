//
//  APSupport.swift
//  APSupport
//
//  Created by localadmin on 18/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import Foundation

struct Profile {
    var Username: String
    var FullName: String
    var MainTicket: String
    init() {
        self.FullName = "Guest";
        self.MainTicket = "NONE";
        self.Username = "Guest";
    }
    
    init(fullname: String, username: String, mainticket: String) {
        self.FullName = fullname;
        self.MainTicket = mainticket;
        self.Username = username;
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
