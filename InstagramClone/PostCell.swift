//
//  PostCell.swift
//  InstagramClone
//
//  Created by Nuruddin on 5/8/17.
//  Copyright © 2017 IUTlab. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
  
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    
    @IBAction func likePressed(_ sender: UIButton) {
    }
    
    @IBAction func unlikePresed(_ sender: Any) {
    }
}
