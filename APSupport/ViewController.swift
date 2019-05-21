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
import Firebase
class ViewController: UIViewController {
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBAction func buttonLogin(_ sender: Any) {
        if ((textUsername.text != nil) && (textPassword.text != nil)){
            
            let username = textUsername.text
            let password = textPassword.text
            APKeyLogin(username: username!, password: password!, CompleteLogin: {
                if (self.isAuthenticated){
                    self.gogo(user: self.user)
                } else {
                    print("Error: Something is wrong")
                }
            })
        }
    }
    let authorName = "Fhan Jacson";
    
    @IBAction func buttonSkipLogin(_ sender: UIButton) {
        //performSegue(withIdentifier: "toMainMenuNoLogin", sender: self)
    }
    
    var user = Profile()
    var Firebasejson = NSDictionary()
    var FAQjson = NSDictionary()
    var Chatjson = NSDictionary()
    var FAQCategoryArray = [String]()
    var MainTicket : String = ""
    var CasTicket : String = ""
    var StudentCourse = [NSDictionary]()
    var StudentProfile = NSDictionary()
    var isAuthenticated : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicator.isHidden = true
        ActivityIndicator.hidesWhenStopped = true
        
        textUsername.text = "TP045027"
        textPassword.text = "POIPOI"
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.Firebasejson = value!
            //print(JSON(self.Firebasejson))
            self.FAQjson = self.Firebasejson["FAQ"] as! NSDictionary
            self.Chatjson = self.Firebasejson["Chat"] as! NSDictionary
            let jsonFAQjson = JSON(self.FAQjson)
            for i in jsonFAQjson {
                //print("#\(i.0)#")
                self.FAQCategoryArray.append(i.0 as String)
            } 
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func APKeyLogin(username: String, password: String, CompleteLogin : @escaping ()->()) {
        ActivityIndicator.isHidden = false
        ActivityIndicator.startAnimating()
        
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
        
        //MAIN TICKET
        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets")!, method: .post, parameters:parameters, headers:headers)
            .validate()
            .response { (response) in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    self.MainTicket = utf8Text;
                    if (self.MainTicket.hasPrefix("TGT")) {
                        
                        //CAS
                        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + self.MainTicket + "?service=https://cas.apiit.edu.my")!, method: .post, headers:headers)
                            .validate()
                            .response { (response) in
                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    print("Data: \(utf8Text)") // original server data as UTF8 string
                                    self.CasTicket = utf8Text
                                    
                                    //STUDENT COURSE
                                    Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + self.MainTicket + "?service=https://api.apiit.edu.my/student/courses")!, method: .post, headers:headers)
                                        .validate()
                                        .responseJSON {
                                            (response) in
                                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                                print("Data: \(utf8Text)") // original server data as UTF8 string
                                                let StudentCourseTicket = utf8Text;
                                                if (StudentCourseTicket.hasPrefix("ST")) {
                                                    Alamofire.request(URL(string: "https://api.apiit.edu.my/student/courses?ticket=" + StudentCourseTicket)!, method: .get, headers:headers)
                                                        .validate()
                                                        .responseJSON {
                                                            (response) in
                                                            let json = JSON(response.result.value!)
                                                            self.StudentCourse = json.arrayObject as! [NSDictionary]
                                                            print("Student Course: \(self.StudentCourse)")
                                                            
                                                            //STUDENT PROFILE
                                                            Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + self.MainTicket + "?service=https://api.apiit.edu.my/student/profile")!, method: .post, headers:headers)
                                                                .validate()
                                                                .responseJSON {
                                                                    (response) in
                                                                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                                                        print("Data: \(utf8Text)") // original server data as UTF8 string
                                                                        let StudentProfileTicket = utf8Text;
                                                                        if (StudentCourseTicket.hasPrefix("ST")) {
                                                                            Alamofire.request(URL(string: "https://api.apiit.edu.my/student/profile?ticket=" + StudentProfileTicket)!, method: .get, headers:headers)
                                                                                .validate()
                                                                                .responseJSON {
                                                                                    (response) in
                                                                                    let json = JSON(response.result.value!)
                                                                                    self.StudentProfile = json.dictionary as! NSDictionary
                                                                                    print("Student Profile: \(self.StudentProfile)")
                                                                                    
                                                                            }
                                                                        }
                                                                    }
                                                            }
                                                            //END
                                                            
                                                            
                                                            
                                                            
                                                            //CAS
                                                            Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/p3/serviceValidate?format=json&service=https://cas.apiit.edu.my&ticket=" + self.CasTicket)!, method: .get, headers:headers)
                                                                .validate()
                                                                .responseJSON {
                                                                    (response) in
                                                                    
                                                                    print(response.request)
                                                                    print(response.response)
                                                                    print(response.data)
                                                                    
                                                                    let json = JSON(response.result.value!)
                                                                    let fullname = json["serviceResponse"]["authenticationSuccess"]["attributes"]["displayName"][0].string
                                                                    
                                                                    let userprofile = Profile.init(fullname: fullname!, username: username, mainticket: self.MainTicket)
                                                                    self.user = userprofile
                                                                    self.isAuthenticated = true;
                                                                    self.ActivityIndicator.stopAnimating()
                                                                    CompleteLogin()
                                                            }
                                                            //END
                                                            
                                                            
                                                            
                                                    }
                                                }
                                            }
                                    }
                                    //END
                                    
                                    
                                    
                                    
                                    
                                }
                                
                        }
                        
                    }
                    //END
                    
                } else {
                    print("Invalid Credential")
                }
                
        }
        //END
        
    }
    
    func gogo(user: Profile) {
        
        performSegue(withIdentifier: "toMainMenu", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMainMenu" {
            print("#ToMainMenu")
            if let NavController = segue.destination as? UINavigationController {
                //                let MainMenu = NavController.viewControllers.first as? MainMenuViewController {
                
                let TabController = NavController.viewControllers.first as! UITabBarController
                let MainMenu = TabController.viewControllers![0] as! MainMenuViewController
                let FAQCategory = TabController.viewControllers![1] as! FAQCategory
                let ChatCategory = TabController.viewControllers![2] as! ChatCategory
                
                
                
                
                MainMenu.user = user
                print("Student Course: \(self.StudentCourse)")
                MainMenu.StudentCourse = self.StudentCourse
                MainMenu.buttonChatEnabled = true
                MainMenu.Firebasejson = self.Firebasejson
                MainMenu.FAQjson = self.FAQjson
                MainMenu.Chatjson = self.Chatjson
                MainMenu.FAQCategoryArray = self.FAQCategoryArray
                
                FAQCategory.FAQjson = self.FAQjson
                FAQCategory.FAQCategoryArray = self.FAQCategoryArray
                FAQCategory.user = user
        
            }
        }
        if segue.identifier == "toMainMenuNoLogin" {
            print("#ToMainMenuNoLogin")
            
            //            if let NavController = segue.destination as? UINavigationController,
            //                let MainMenu = NavController.viewControllers.first as? MainMenuViewController {
            //                MainMenu.buttonChatEnabled = false
            //                MainMenu.user = Profile()
            //
            //                var ref: DatabaseReference!
            //                ref = Database.database().reference()
            //
            //                ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //                    // Get user value
            //                    let value = snapshot.value as? NSDictionary
            //                    self.Firebasejson = value!
            //                    print(JSON(self.Firebasejson))
            //                    self.FAQjson = self.Firebasejson["FAQ"] as! NSDictionary
            //                    self.Chatjson = self.Firebasejson["Chat"] as! NSDictionary
            //                    print("faq array count: \(self.FAQjson.count)")
            //                    print("chat array count: \(self.Chatjson.count)")
            //                    MainMenu.Firebasejson = self.Firebasejson
            //                    MainMenu.FAQjson = self.FAQjson
            //                    MainMenu.Chatjson = self.Chatjson
            //                    let jsonFAQjson = JSON(self.FAQjson)
            //                    for i in jsonFAQjson {
            //                        print("#\(i.0)#")
            //                        self.FAQCategoryArray.append(i.0 as String)
            //                    }
            //                    MainMenu.FAQCategoryArray = self.FAQCategoryArray
            //                    // ...
            //                }) { (error) in
            //                    print(error.localizedDescription)
            //                }
            //
            //
            //            }
            
        }
        
        
    }
}
