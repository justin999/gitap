//
//  FeedsTableViewCell.swift
//  gitap
//
//  Created by Koichi Sato on 12/24/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    @IBOutlet weak var issueNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData() {
//        if let issue = issue {
//            issueNameLabel.text = issue.title
//        }
    }
    
}
