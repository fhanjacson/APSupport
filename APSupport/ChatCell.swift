//
//  ChatCell.swift
//  APSupport
//
//  Created by Jacson on 23/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase

class ChatCell: UITableViewCell {
    var message : String?
    var username : String?
    var timestamp : Timestamp?
    
    var messageView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var usernameView : UILabel = {
        var labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    var timestampView : UILabel = {
        var labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageView)
        self.addSubview(usernameView)
        self.addSubview(timestampView)
        
        //messageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        //messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //messageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //messageView.bottomAnchor.constraint(equalTo: self.usernameView.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.usernameView.topAnchor).isActive = true
        //messageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        //messageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //timestampView.topAnchor.constraint(equalTo: self.messageView.bottomAnchor).isActive = true
        //usernameView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        //usernameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //usernameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        usernameView.textAlignment = .right
        
        //timestampView.bottomAnchor.constraint(equalTo: self.usernameView.topAnchor).isActive = true
        
        //usernameView.topAnchor.constraint(equalTo: self.messageView.bottomAnchor).isActive = true
        //usernameView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        //usernameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //usernameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let message = message {
        messageView.text = message
        }
        if let username = username {
            usernameView.text = username
        }
        if let timestamp = timestamp {
            
            let timestampString = DateFormatter().string(from: timestamp.dateValue())
            
            timestampView.text = timestampString
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
