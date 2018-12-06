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
    
    let audioEngine = AVAudioEngine()
    var stringCopyChecker = ""
    @IBOutlet weak var errorDiv: UITextField!
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    
    @IBOutlet weak var voiceStartBtn: UIButton!
    @IBOutlet weak var categoryText: UITextField!
    let request = SFSpeechAudioBufferRecognitionRequest()
    
    var recognitionTask: SFSpeechRecognitionTask?
    var ref:DatabaseReference?
    @IBOutlet weak var DetailsTitle: UILabel!
    
    
    @IBAction func startVoice(_ sender: Any) {
        recordAndRecognizeSpeech()
    }
    @IBOutlet weak var DetailsContextLarger: UITextView!
    
    var voiceBtnClicked = true
    
    func checkForCommandsSaid(resultString: String)-> Bool{
        
        
        let resultString = resultString.lowercased()
        
        if(resultString == "back"){
            self.backButton(self)
            return false
        }
        
        if(resultString == "clear"){
            self.DetailsContextLarger.text = ""
            self.errorDiv.text = "Cleared!"
            return false
        }
        
       // self.ref!.child("users/" + Auth.auth().currentUser!.uid + "/categories" ).child("(l)" + categoryName!).childByAutoId().setValue("empty")
        if(resultString == "save"){
            self.ref!.child("users/" + Auth.auth().currentUser!.uid + "/categories" ).child(detailTitle).child("p").setValue(DetailsContextLarger.text)
            self.errorDiv.text = "Saved!"
            return false
        }
        
        return true
     
    }
    
    func recordAndRecognizeSpeech(){
        
        if(voiceBtnClicked == false ) {
            print("restarting")
            self.recognitionTask?.cancel();
            self.audioEngine.inputNode.removeTap(onBus: 0)
            //self.voiceStartBtn.isEnabled = true
            voiceBtnClicked = true
            self.errorDiv.text = "Click Voice One More Time!"
            //recordAndRecognizeSpeech()
        } else {
            print("starting")
            self.errorDiv.text = "Voice Recording On!";
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
                    
                    if(self.checkForCommandsSaid(resultString: lastString)){
                    
                    if(lastString.lowercased() == "finish"){
                        self.categoryText.text = ""
                        self.recognitionTask?.cancel();
                        self.audioEngine.inputNode.removeTap(onBus: 0)
                        self.voiceStartBtn.isEnabled = true
                        self.errorDiv.text = "Cancelled Voice Recording"
                        return;
                        
                        
                    } else {
                        
                        if self.stringCopyChecker.range(of:lastString) != nil {
                            
                        }else {
                            self.categoryText.text =  lastString
                            self.stringCopyChecker = lastString;
                            self.DetailsContextLarger.text = self.DetailsContextLarger.text + " " + lastString
                        }
                    }
                    }
                    
                    
                }else if let error = error{
                    print("the speech is not detected")
                    print(error)
                }
                
                
                
            })
            
        }
        
    }
    
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

