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

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    

    @IBOutlet weak var userLabel: UITextField!
    
    @IBOutlet weak var tabelView: UITableView!
    
    var ref:DatabaseReference?
    var postData = [String]()
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let err {
            print(err)
        }
        
    }
    
    @IBOutlet var tableView: [UITableView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user is", Auth.auth().currentUser?.email)
        userLabel.text = "USER" + (Auth.auth().currentUser?.email)!
        
        
        

        // Do any additional setup after loading the view, typically from a nib.
        
        //set firebase ref
        ref = Database.database().reference()
        
        //retreive posts and listen.
        ref?.child("posts").observe(.childAdded, with: {
                (snapshot) in
            let post = snapshot.value as? String
            
            if let actualPost = post {
                self.postData.append(actualPost)
                self.tabelView.reloadData()
            }
            
            print(self.postData)
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = postData[indexPath.row]
        
        return(cell)
        
    }


}

