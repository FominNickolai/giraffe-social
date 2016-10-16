//
//  FeedVC.swift
//  giraffe-social-firebase
//
//  Created by admin on 10/13/16.
//  Copyright © 2016 com.giraffe. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.append(post)
                        
                    }
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        
        })
        
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        
        let _ = KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(KEY_UID)
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss(animated: true, completion: nil)
        
    }


}

extension FeedVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        print("NICK: \(post.caption)")
        
        return cell
        
    }
    
}

extension FeedVC: UITableViewDelegate {
    
    
    
}

































