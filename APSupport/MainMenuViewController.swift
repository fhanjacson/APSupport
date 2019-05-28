//
//  MainMenuViewController.swift
//  APSupport
//
//  Created by localadmin on 17/05/2019.
//  Copyright © 2019 Fhan Jacson. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Alamofire
import Alamofire_SwiftyJSON

class MainMenuViewController: UIViewController {
    @IBAction func buttonLogOut(_ sender: Any) {
        performSegue(withIdentifier: "ToLoginPage", sender: self)
    }
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var IntakeLabel: UILabel!
    @IBOutlet weak var GuestLabel: UILabel!
    @IBOutlet weak var imageProfilePicture: UIImageView!
    var user = Profile()
    var Firebasejson = NSDictionary()
    var FAQjson = NSDictionary()
    var Chatjson = NSDictionary()
    var FAQCategoryArray = [String]()
    var StudentCourse = [NSDictionary]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("")
        print("#MainMenuViewController")
        
        welcomeLabel.isHidden = true
        IntakeLabel.isHidden = true
        GuestLabel.numberOfLines = 0
        GuestLabel.text = "Guest doesnt have dashboard. Login with your APKey to view your dashboard"
        
        welcomeLabel.numberOfLines = 0
        if user.FullName != "Guest" {
            GuestLabel.isHidden = true
            welcomeLabel.isHidden = false
            IntakeLabel.isHidden = false
            let StudentIntake : String! = StudentCourse[0]["INTAKE_CODE"] as! String
            welcomeLabel.text = "Name: \(user.FullName)"
            IntakeLabel.text = "Intake: \(StudentIntake!)"
            getProfilePicture()
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getProfilePicture () {
        //STUDENT PROFILE PICTURE
        Alamofire.request(URL(string: "https://cas.apiit.edu.my/cas/v1/tickets/" + user.MainTicket + "?service=https://api.apiit.edu.my/student/photo")!, method: .post, headers:APSupport.headers)
            .validate()
            .responseJSON {
                (response) in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    let StudentProfilePictureTicket = utf8Text;
                    if (StudentProfilePictureTicket.hasPrefix("ST")) {
                        Alamofire.request(URL(string: "https://api.apiit.edu.my/student/photo?ticket=" + StudentProfilePictureTicket)!, method: .get, headers:APSupport.headers)
                            .validate()
                            .responseJSON {
                                (response) in
                                let json = JSON(response.result.value!)
                                let ProfilePictureData = NSData(base64Encoded: json["base64_photo"].string!, options: NSData.Base64DecodingOptions(rawValue: 0))
                                let ProfileImage: UIImage = UIImage(data: ProfilePictureData! as Data)!
                                self.imageProfilePicture.image = ProfileImage
                        }
                    }
                }
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toFAQCategory" {
            
        }
    }
    
    
    
}
