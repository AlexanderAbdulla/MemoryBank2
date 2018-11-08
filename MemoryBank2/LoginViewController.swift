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

    @IBAction func LogIn(_ sender: Any) {
        ref = Database.database().reference();      ref.child("stats").setValue(["clicks": 5])
        
          // ...
        Auth.auth().createUser(withEmail: "a@a.com", password: "aaaaaa")

        //performSegue(withIdentifier: "LoginSegue", sender: self)
        
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
