//
//  CNNCell.swift
//  CariocaMenuDemo
//
//  Created by Hell Rocky on 8/1/19.
//  Copyright © 2019 CariocaMenu. All rights reserved.
//

import UIKit

class CNNCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.layer.cornerRadius = 5
        name.layer.borderWidth = 2
        name.layer.borderColor = UIColor(hex: "#34B2FF").cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
