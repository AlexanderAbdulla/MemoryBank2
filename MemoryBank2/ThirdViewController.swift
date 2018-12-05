//
//  ThirdViewController.swift
//  MemoryBank2
//
//  Created by Alex Abdulla on 2018-12-05.
//  Copyright © 2018 Alex Abdulla. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var DetailsTitle: UILabel!
    var detailTitle = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailsTitle.text  = detailTitle;
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
