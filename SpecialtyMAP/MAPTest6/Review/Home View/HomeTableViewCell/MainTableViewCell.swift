//
//  MainTableViewCell.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/30.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    // 商品名
    @IBOutlet weak var speName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
