//
//  FirstViewController.swift
//  MemoryBank2
//
//  Created by Alex Abdulla on 2018-11-07.
//  Copyright © 2018 Alex Abdulla. All rights reserved.
//

import UIKit
import FirebaseCore
import Firebase

class FirstViewController: UIViewController {

    @IBOutlet weak var userLabel: UITextField!
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let err {
            print(err)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user is", Auth.auth().currentUser?.email)
        userLabel.text = "USER" + (Auth.auth().currentUser?.email)!
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    


}

