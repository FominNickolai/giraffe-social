//
//  PostCell.swift
//  giraffe-social-firebase
//
//  Created by admin on 10/13/16.
//  Copyright © 2016 com.giraffe. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
            
        })
        
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        caption.text = post.caption
        likesLbl.text = "\(post.likes)"
        
        if img != nil {
            
            postImg.image = img
            
        } else {
            
            let imageUrl = post.imageUrl
            
            let ref = FIRStorage.storage().reference(forURL: imageUrl)
            
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    
                    print("NICK: Unable to download image from Firebase storage")
                    
                } else {
                    
                    print("NICK: Image download from Firebase storage")
                    
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: imageUrl as NSString)
                            
                        }
                        
                    }
                    
                }
                
            })
                
            
            
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let _ = snapshot.value as? NSNull {
                
                self.likeImage.image = UIImage(named: "empty-heart")
                
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
            
        })
        
    }

}
