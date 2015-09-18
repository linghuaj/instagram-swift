//
//  FeedCell.swift
//  instagram
//
//  Created by Linghua Jin on 9/17/15.
//  Copyright (c) 2015 ljin. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var feedImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // create a rounded corner image
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2;
        self.userImg.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
