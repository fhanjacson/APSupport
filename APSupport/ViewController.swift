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
        performSegue(withIdentifier: "toMainMenuNoLogin", sender: self)
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
    var ChatCategoryList = [String]()
    var isAuthenticated : Bool = false
    var ProfilePicture = UIImage()
    
    var ChatObject = [NSDictionary]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
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
        //getChatCategory()
        getChatObject()
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
        
        //MAIN TICKET
        
        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets")!, method: .post, parameters:parameters, headers: APSupport.headers)
            .validate()
            .response { (response) in
                if(response.error == nil) {
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("MAIN TICKET: \(utf8Text)") // original server data as UTF8 string
                        self.MainTicket = utf8Text;
                        if (self.MainTicket.hasPrefix("TGT")) {
                            
                            //CAS
                            Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + self.MainTicket + "?service=https://cas.apiit.edu.my")!, method: .post, headers:APSupport.headers)
                                .validate()
                                .response { (response) in
                                    if (response.error == nil) {
                                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                        print("CAS TICKET: \(utf8Text)") // original server data as UTF8 string
                                        self.CasTicket = utf8Text
                                        
                                        //STUDENT COURSE
                                        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + self.MainTicket + "?service=https://api.apiit.edu.my/student/courses")!, method: .post, headers:APSupport.headers)
                                            .validate()
                                            .responseJSON {
                                                (response) in
                                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                                    print("STUDENT COURSE TICKET: \(utf8Text)") // original server data as UTF8 string
                                                    let StudentCourseTicket = utf8Text;
                                                    if (StudentCourseTicket.hasPrefix("ST")) {
                                                        Alamofire.request(URL(string: "https://api.apiit.edu.my/student/courses?ticket=" + StudentCourseTicket)!, method: .get, headers:APSupport.headers)
                                                            .validate()
                                                            .responseJSON {
                                                                (response) in
                                                                let json = JSON(response.result.value!)
                                                                self.StudentCourse = json.arrayObject as! [NSDictionary]
                                                                //print("Student Course: \(self.StudentCourse)")
                                                                
                                                                //STUDENT PROFILE
                                                                Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + self.MainTicket + "?service=https://api.apiit.edu.my/student/profile")!, method: .post, headers:APSupport.headers)
                                                                    .validate()
                                                                    .responseJSON {
                                                                        (response) in
                                                                        //if (response.error == nil) {
                                                                            //print(response.error)
                                                                        
                                                                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                                                                print("PROFILE TICKET: \(utf8Text)") // original server data as UTF8 string
                                                                                let StudentProfileTicket = utf8Text;
                                                                                if (StudentCourseTicket.hasPrefix("ST")) {
                                                                                    Alamofire.request(URL(string: "https://api.apiit.edu.my/student/profile?ticket=" + StudentProfileTicket)!, method: .get, headers:APSupport.headers)
                                                                                        .validate()
                                                                                        .responseJSON {
                                                                                            (response) in
                                                                                            //if (response.error == nil) {
                                                                                                let json = JSON(response.result.value!)
                                                                                                self.StudentProfile = json.dictionary! as NSDictionary
                                                                                                //print("Student Profile: \(self.StudentProfile)")
                                                                                                
                                                                                                //CAS
                                                                                                Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/p3/serviceValidate?format=json&service=https://cas.apiit.edu.my&ticket=" + self.CasTicket)!, method: .get, headers:APSupport.headers)
                                                                                                    .validate()
                                                                                                    .responseJSON {
                                                                                                        (response) in
                                                                                                        
                                                                                                        let json = JSON(response.result.value!)
                                                                                                        let fullname = json["serviceResponse"]["authenticationSuccess"]["attributes"]["displayName"][0].string
                                                                                                        
                                                                                                        let userprofile = Profile.init(fullname: fullname!, username: username, mainticket: self.MainTicket)
                                                                                                        self.user = userprofile
                                                                                                        self.isAuthenticated = true;
                                                                                                        self.ActivityIndicator.stopAnimating()
                                                                                                        CompleteLogin()
                                                                                                }
                                                                                                //END
                                                                                                
                                                                                            //}
                                                                                    //else {
                                                                                                //self.ActivityIndicator.stopAnimating()
                                                                                                //self.present(APSupport.newAlert(title: "Error",message: "Something went wrong, check your internet connection"), animated: true)
                                                                                            //}
                                                                                    }
                                                                                }
                                                                            }
                                                                        //END
                                                                }
                                                        }
                                                    }
                                                }
                                                //END
                                        }
                                    }
                                    } else {
                                        self.ActivityIndicator.stopAnimating()
                                        self.present(APSupport.newAlert(title: "Error",message: "Wrong Username or Password / Internet Problem"), animated: true)
                            }
                            }
                            //END
                            
                        } else {
                            self.ActivityIndicator.stopAnimating()
                            self.present(APSupport.newAlert(title: "Error",message: "Something went wrong, check your internet connection"), animated: true)
                        }
                        
                    }
                } else {
                    self.ActivityIndicator.stopAnimating()
                    self.present(APSupport.newAlert(title: "Error",message: "Something went wrong, check your internet connection"), animated: true)                        }
                //END
        }
        }
        
        func gogo(user: Profile) {
            
            performSegue(withIdentifier: "toMainMenu", sender: self)
            
        }
        
        func getChatObject() {
            let db = Firestore.firestore()
            db.collection("OnlineChat").document("General").collection("messages").addSnapshotListener {
                (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        self.ChatObject.append(document.data() as NSDictionary)
                    }
                    //print(self.ChatObject)
                    //print(JSON(self.ChatObject))
                    
                    
                }
            }
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
                    let FavouriteFAQ = TabController.viewControllers![3] as! FavouriteFAQ
                    
                    MainMenu.user = user
                    //print("Student Course: \(self.StudentCourse)")
                    MainMenu.StudentCourse = self.StudentCourse
                    MainMenu.Firebasejson = self.Firebasejson
                    MainMenu.FAQjson = self.FAQjson
                    MainMenu.Chatjson = self.Chatjson
                    MainMenu.FAQCategoryArray = self.FAQCategoryArray
                    
                    FAQCategory.FAQjson = self.FAQjson
                    FAQCategory.FAQCategoryArray = self.FAQCategoryArray
                    FAQCategory.user = user
                    
                    ChatCategory.ChatCategoryList = self.ChatCategoryList
                    //ChatCategory.tempvar = "abc"
                    ChatCategory.user = self.user
                    
                    FavouriteFAQ.user = self.user
                    FavouriteFAQ.FAQjson = self.FAQjson
                    print("End of #ViewController")
                }
            }
            if segue.identifier == "toMainMenuNoLogin" {
                print("#ToMainMenuNoLogin")
                if let NavController = segue.destination as? UINavigationController {
                    //                let MainMenu = NavController.viewControllers.first as? MainMenuViewController {
                    
                    let TabController = NavController.viewControllers.first as! UITabBarController
                    let MainMenu = TabController.viewControllers![0] as! MainMenuViewController
                    let FAQCategory = TabController.viewControllers![1] as! FAQCategory
                    let ChatCategory = TabController.viewControllers![2] as! ChatCategory
                    
                    //MainMenu.user = Profile()
                    //print("Student Course: \(self.StudentCourse)")
                    //MainMenu.StudentCourse = self.StudentCourse
                    MainMenu.Firebasejson = self.Firebasejson
                    MainMenu.FAQjson = self.FAQjson
                    MainMenu.Chatjson = self.Chatjson
                    MainMenu.FAQCategoryArray = self.FAQCategoryArray
                    
                    FAQCategory.FAQjson = self.FAQjson
                    FAQCategory.FAQCategoryArray = self.FAQCategoryArray
                    //FAQCategory.user = user
                    
                    ChatCategory.ChatCategoryList = self.ChatCategoryList
                    //ChatCategory.tempvar = "abc"
                    //ChatCategory.user = self.user
                    print("End of #ViewController")
                }
                
            }
            
            
        }
}

