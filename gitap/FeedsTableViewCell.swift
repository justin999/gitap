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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(event: Event) {
        self.issueNameLabel.text = event.type
    }
    
}
