//
//  Login.swift
//  TrickorEatApp
//
//  Created by toxin_4500 on 2018-03-27.
//  Copyright © 2018 cis_4500. All rights reserved.
//

import UIKit

class Login: UIViewController {

    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginButton.layer.cornerRadius = 8
        LoginButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AttemptLogin(_ sender: UIButton) {
        
        let login_usr = EmailField.text!
        let login_pass = PasswordField.text!
        
        print(login_usr + " " + login_pass)
        
        //validate email structure
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        if (test.evaluate(with: login_usr) == false) {
            print("Invalid")
            EmailField.textColor = UIColor.red
        } else {
            print("Valid")
            
            //continue
            
            //check backend API
            
            //transition
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
