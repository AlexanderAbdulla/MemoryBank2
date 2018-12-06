//
//  ThirdViewController.swift
//  MemoryBank2
//
//  Created by Alex Abdulla on 2018-12-05.
//  Copyright © 2018 Alex Abdulla. All rights reserved.
//

import UIKit
import FirebaseCore
import Firebase
import Speech
import Accelerate

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = postData[indexPath.row]
        
        return(cell)
        
    }

    @IBOutlet weak var DetailsTitle: UILabel!
    var detailTitle = "";
    var postData = [String]()
    var ref:DatabaseReference?
    
    @IBOutlet weak var tabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailsTitle.text  = detailTitle;
        ref = Database.database().reference();        let nodeString = "users/" + (Auth.auth().currentUser?.uid)! + "/categories/" + detailTitle;
        
        postData.removeAll()
        
        //retreive posts and listen.
        ref?.child(nodeString).observe(.childAdded, with: {
            (snapshot) in
            let post = snapshot.value as? String //used to be value
            
            if let actualPost = post {
                self.postData.append(actualPost)
                self.tabelView.reloadData()
            }
            
            print(self.postData)
        })
        
        //postData.removeAll { $0 == selectedTitle}
        tabelView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
