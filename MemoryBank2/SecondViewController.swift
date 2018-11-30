//
//  SecondViewController.swift
//  MemoryBank2
//
//  Created by Alex Abdulla on 2018-11-07.
//  Copyright © 2018 Alex Abdulla. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var DetailsTitle: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
     //performSegue(withIdentifier: "categoriesSegue", sender: self)
        self.dismiss(animated: true, completion: nil)    }
    
    var detailTitle = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailsTitle.text = detailTitle
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

