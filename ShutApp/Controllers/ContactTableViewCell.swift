//
//  ContactTableViewCell.swift
//  ShutApp
//
//  Created by Erik Ugarte on 2020-11-27.
//  Copyright © 2020 ShutAppOrg. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
