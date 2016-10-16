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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let key = KeychainWrapper.defaultKeychainWrapper().stringForKey(KEY_UID) {
            print(key)
            performSegue(withIdentifier: "goToFeed", sender: self)
            
        }
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
                if let user = user {
                    
                    let userData = ["provider" : credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                    
                }
                
                
            }
            
        })
        
    }
    
    @IBAction func signInTapped(_ sender: FancyBtn) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    
                    print("NICK: Email user authenticated Successfully with Firebase")
                    
                    if let user = user {
                        
                        let userData = ["provider" : user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                        
                    }
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("NICK: Unable to authenticate with Firebase using email")
                        } else {
                            print("NICK: Successfully created user in Firebase")
                            
                            if let user = user {
                                let userData = ["provider" : user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                                
                            }
                        }
                    })
                    
                }
                
            })
            
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        _ = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_UID)
        print("NICK: Data saved to keychain successfully")
        performSegue(withIdentifier: "goToFeed", sender: self)
    }

}

