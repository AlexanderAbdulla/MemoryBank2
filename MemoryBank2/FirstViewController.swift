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
    
    @IBOutlet weak var categoryText: UITextField!
    
    
    var ref:DatabaseReference?
    var postData = [String]()
    var postKeys = [String]()
    var selectedIndex = 0;
    var selectedTitle = "none selected";
    
    @IBAction func deleteCategory(_ sender: Any) {
       
        let nodeString = "users/" + (Auth.auth().currentUser?.uid)! + "/categories";
        
        ref?.child(nodeString).observe(.childAdded, with: {
            (snapshot) in
            let post = snapshot.value as? String
            
            if let actualPost = post {
                if (self.selectedTitle == actualPost){
                    snapshot.ref.removeValue();
                }
            }
            
           // print(self.postData)
           
        }
        )
        
        
        postData.removeAll { $0 == selectedTitle}
        tabelView.reloadData()
        //self.viewDidLoad()
        
       // postData.removeAll();
        //tabelView.reloadData()
        

    }
    
    @IBAction func addCategory(_ sender: Any) {
        var categoryName = categoryText.text
        
        
        
        self.ref!.child("users/" + Auth.auth().currentUser!.uid + "/categories" ).childByAutoId().setValue(categoryName)
     
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            //TODO instead of dismiss perform a segue here
            //performSegue(withIdentifier: "LoginSegue", sender: self)
            
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
        
        let nodeString = "users/" + (Auth.auth().currentUser?.uid)! + "/categories";
        
        postData.removeAll()
        
        //retreive posts and listen.
        ref?.child(nodeString).observe(.childAdded, with: {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recieverVC = segue.destination as! SecondViewController;
        
        recieverVC.detailTitle = selectedTitle;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(postData[indexPath.row])
        
        if(selectedTitle == postData[indexPath.row]){
             performSegue(withIdentifier: "DetailsSegue", sender: self)
            
        }
        
        selectedTitle = postData[indexPath.row]
        
        
    }

}

