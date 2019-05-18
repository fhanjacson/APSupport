//
//  ViewController.swift
//  APSupport
//
//  Created by localadmin on 26/04/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON
class ViewController: UIViewController {
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBAction func buttonLogin(_ sender: Any) {
        if ((textUsername.text != nil) && (textPassword.text != nil)){
            
            var username = textUsername.text
            var password = textPassword.text
            APKeyLogin(username: username!, password: password!)
        }
    }
    let authorName = "Fhan Jacson";
    
    @IBAction func buttonSkipLogin(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicator.stopAnimating()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func APKeyLogin(username: String, password: String) {
        ActivityIndicator.startAnimating()
        var ticket1: String = ""
        var ticket2: String = ""
        var isAuthenticated: Bool = false;
        
        let parameters = [
            "username" : username,
            "password" : password
        ]
        
        let headers: HTTPHeaders = [
            "Accept":"application/json, text/plain, */*",
            "Content-type":"application/x-www-form-urlencoded",
            "Origin":"https://apspace.apu.edu.my",
            "Referer":"https://apspace.apu.edu.my/",
            "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
        ]
        
        //Alamofire.request(URL(string: "https://postman-echo.com/post")!, method: .post, parameters: parameters)
        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets")!, method: .post, parameters:parameters, headers:headers)
            .validate()
            .response { (response) in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    ticket1 = utf8Text;
                    if (ticket1.hasPrefix("TGT")) {
                        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + ticket1 + "?service=https://cas.apiit.edu.my")!, method: .post, headers:headers)
                            .validate()
                            .response { (response) in
                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    print("Data: \(utf8Text)") // original server data as UTF8 string
                                    ticket2 = utf8Text
                                    Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/p3/serviceValidate?format=json&service=https://cas.apiit.edu.my&ticket=" + ticket2)!, method: .get, headers:headers)
                                        .validate()
                                        .responseJSON {
                                            (response) in
                                            let json = JSON(response.result.value!)
                                            let fullname = json["serviceResponse"]["authenticationSuccess"]["attributes"]["displayName"][0].string
                                            let mainticket = ticket2
                                            let userprofile = Profile.init(Username: username, FullName: fullname!, MainTicket: mainticket)
                                            
                                            print("Username: \(userprofile.Username)")
                                            print("Full Name: \(userprofile.FullName)")
                                            print("Ticket: \(userprofile.MainTicket)")
                                            isAuthenticated = true;
                                            if (isAuthenticated){
                                                self.gogo()
                                            } else {
                                                print("Error: Something is wrong")
                                            }
                                            
                                    }
                                    
                                }
                        }
                        
                    }
                } else {
                    print("Invalid Credential")
                }
                self.ActivityIndicator.stopAnimating()
        }
        
        
        
}
    
    func gogo() {
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainMenu" {
            
        }
    }
    
}
//                                        .responseJSON {
//                                            response in
//                                            if let serviceResponse = response.result.value as? [String: Any] {
//                                                if let authenticationSuccess = serviceResponse["serviceResponse"] as? [String: Any] {
//                                                    if let attributes = authenticationSuccess["authenticationSuccess"] as? [String: Any] {
//                                                        print(attributes["attributes"])
//                                                    }
//                                                }
//                                            }
//                                        }
//                                        .response { (response) in
//                                            if let data = response.data {
//                                                do {
//
//                                                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                                                    print(json)
//
//                                                    let jsonArray = json as? [String: Any]
//                                                    print("123")
//                                                    print(jsonArray)
//                                                    print("abc")
//
//                                                } catch {
//                                                    print("Error: ", error)
//                                                }
//                                            }
//                                    }

//        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + ticket1 + "?service=https://cas.apiit.edu.my")!, method: .post, headers:headers)
//            .validate()
//            .response { (response) in
//                print("Request: \(response.request)")
//                print("Response: \(response.response)")
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
//                    ticket2 = utf8Text
//                }
//        }
//
//        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/p3/serviceValidate?format=json&service=https://cas.apiit.edu.my&ticket=" + ticket2)!, method: .get, headers:headers)
//            .validate()
//            .response { (response) in
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
//                    ticket2 = utf8Text
//                }
//                if let data = response.data {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(json)
//                    } catch {
//                        print("Error: ", error)
//                    }
//                }
//        }
