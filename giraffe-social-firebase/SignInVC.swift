//
//  ViewController.swift
//  giraffe-social-firebase
//
//  Created by admin on 10/10/16.
//  Copyright © 2016 com.giraffe. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookPressed(_ sender: RoundButton) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
            
            if error != nil {
                print("NICK: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("NICK: User cancelled authenticate with Facebook")
            } else {
                print("NICK: Successfully Logged in with Facebook")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: result!.token.tokenString)
                
                self.firebaseAuth(credential)
            }
            
        })
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("NICK: Unable to authenticate with Firebase - \(error)")
                
            } else {
                
                print("NICK: Successfulle authenticated with Firebase")
                
            }
            
        })
        
    }
    

}

