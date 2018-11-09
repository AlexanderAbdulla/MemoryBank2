//
//  LoginViewController.swift
//  MemoryBank2
//
//  Created by Alex Abdulla on 2018-11-07.
//  Copyright © 2018 Alex Abdulla. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
  var ref: DatabaseReference!

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorText: UITextField!
    
    
    @IBAction func LogIn(_ sender: Any) {
        var usernameText = usernameField.text
        
        var passwordText = passwordField.text
        
        Auth.auth().signIn(withEmail: usernameText!, password: passwordText!) { (user, error) in
            
            if error != nil {
                print("firebase auth ", error.debugDescription);
                self.errorText.text = error?.localizedDescription
            } else {
                print("all good...continue")
                self.changeView()
                
            }
        
        }
    }
    
    @IBAction func SingUp(_ sender: Any) {
        ref = Database.database().reference();   ref.child("stats").setValue(["clicks": 5])
        
        
        var usernameText = usernameField.text
        
        var passwordText = passwordField.text
        
        // ...
        Auth.auth().createUser(withEmail: usernameText!, password: passwordText!) { (user, error) in
            
            if error != nil {
                
                print("firebase auth ", error.debugDescription)
                self.errorText.text = error?.localizedDescription                //self.changeView()
                
            } else {
                print("all good... continue")
                self.changeView()
            }
        }
        
    }
    
    
    
    func changeView(){
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
