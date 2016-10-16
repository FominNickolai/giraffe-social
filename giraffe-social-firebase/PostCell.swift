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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, img: UIImage? = nil) {
        
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
        
    }

}
