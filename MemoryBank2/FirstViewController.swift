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
import Speech
import Accelerate

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    
    @IBOutlet weak var voiceStartBtn: UIButton!
    
    @IBOutlet weak var userLabel: UITextField!
    
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var categoryText: UITextField!
    
    let audioEngine = AVAudioEngine()
    
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    
    let request = SFSpeechAudioBufferRecognitionRequest()
    
    var recognitionTask: SFSpeechRecognitionTask?
    
    var ref:DatabaseReference?
    var postData = [String]()
    var postKeys = [String]()
    var selectedIndex = 0;
    var selectedTitle = "none selected";
    var voiceBtnClicked = true;
 
    @IBAction func voiceStart(_ sender: Any) {
        print("we are in the mothafuckin button yo")
        self.recordAndRecognizeSpeech()
        
    }
    
    func checkForCommandsSaid(resultString: String){
       
        
        let resultString = resultString.lowercased()
        
        switch resultString {
            
        case "clear":
            categoryText.text = ""
        case "add":
           // selectedTitle = categoryText.text!
            self.addCategory(self)
            print("in add case")
        case "edit":
            selectedTitle = categoryText.text!
            self.editCategory(self)
        case "delete":
            selectedTitle = categoryText.text!
            self.deleteCategory(self)
        case "select":
            selectedTitle = categoryText.text!
            performSegue(withIdentifier: "DetailsSegue", sender: self)
            //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
            
            
            
        default: break
        }
    }
    
    func recordAndRecognizeSpeech(){
        
        if(voiceBtnClicked == false ) {
            print("restarting")
            self.recognitionTask?.cancel();
            self.audioEngine.inputNode.removeTap(onBus: 0)
            //self.voiceStartBtn.isEnabled = true
            voiceBtnClicked = true
            //recordAndRecognizeSpeech()
        } else {
        print("starting")
        voiceBtnClicked = false;
        
        // this syntax differs slightly as i cant seem to use the else/ gaurd
        let node = audioEngine.inputNode;
        
        print("we made a node")
        
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {buffer, _ in self.request.append(buffer)}
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audio engine didnt work")
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            print("sf speech recognizer didnt work")
            return
        }
        
        if !myRecognizer.isAvailable {
            print("available didnt work")
            return
        }
        
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result{
                
                var bestString = result.bestTranscription.formattedString
                
                var lastString: String = ""
                
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
                
                self.checkForCommandsSaid(resultString: lastString)
                
                if(lastString.lowercased() == "finish"){
                    self.categoryText.text = ""
                    self.recognitionTask?.cancel();
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    self.voiceStartBtn.isEnabled = true
                    //self.colorDisplay.backgroundColor =  UIColor.white
                    //var image: UIImage? = nil
                    //self.darcyView.image = image
                    return;
                    
                    
                } else {
                    self.categoryText.text = lastString
                }
                
                
            }else if let error = error{
                print("the speech is not detected")
                print(error)
            }
            
            
            
        })
        
        }
        
    }
    @IBAction func deleteCategory(_ sender: Any) {
       
        let nodeString = "users/" + (Auth.auth().currentUser?.uid)! + "/categories";
        
        ref?.child(nodeString).observe(.childAdded, with: {
            (snapshot) in
            let post = snapshot.key as? String
            
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
        //print("in add cat")
        
        var categoryName = categoryText.text?.lowercased()
        
        //print("adding")
        //print(categoryName)
        
       // self.ref!.child("users/" + Auth.auth().currentUser!.uid + "/categories" ).childByAutoId().setValue(categoryName)
        self.ref!.child("users/" + Auth.auth().currentUser!.uid + "/categories" ).child(categoryName!).setValue("EMPTY")
        
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
    
    @IBAction func editCategory(_ sender: Any) {
        
        
        print("in edit fx")
        
        let nodeString = "users/" + (Auth.auth().currentUser?.uid)! + "/categories";
        
        ref?.child(nodeString).observe(.childAdded, with: {
            (snapshot) in
            let post = snapshot.key as? String
            
            if let actualPost = post {
                if (self.selectedTitle == actualPost){
                    snapshot.ref.setValue(self.categoryText.text?.lowercased())
                    for i in 0..<(self.postData.count) {
                        if(self.postData[i] == self.selectedTitle){
                            self.postData[i] = self.categoryText.text!;
                            self.tabelView.reloadData()
                        }
                    }
                }
            }
            
            // print(self.postData)
            
        }
        
        )
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
            let post = snapshot.key as? String //used to be value
            
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

