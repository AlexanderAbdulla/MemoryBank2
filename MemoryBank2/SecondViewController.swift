//
//  SecondViewController.swift
//  MemoryBank2
//
//  Created by Alex Abdulla on 2018-11-07.
//  Copyright © 2018 Alex Abdulla. All rights reserved.
//

import UIKit
import FirebaseCore
import Firebase
import Speech
import Accelerate

class SecondViewController: UIViewController {
    
    var ref:DatabaseReference?
    @IBOutlet weak var DetailsTitle: UILabel!
    
    
    @IBOutlet weak var DetailsContextLarger: UITextView!
    
    @IBAction func backButton(_ sender: Any) {
     //performSegue(withIdentifier: "categoriesSegue", sender: self)
        self.dismiss(animated: true, completion: nil)    }
    

    
    var detailTitle = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailsTitle.text = detailTitle
        
        
        ref = Database.database().reference()
        let nodeString = "users/" + (Auth.auth().currentUser?.uid)! + "/categories/" + detailTitle;
        
        ref?.child(nodeString).observe(.childAdded, with: {
            (snapshot) in
            let post = snapshot.key as? String //used to be value
            
            self.DetailsContextLarger.text  = snapshot.value! as! String
            
           // print(self.postData)
        })        // Do any additional setup after loading the view, typically from a nib.
    }


}

