//
//  TableViewCell.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/10.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    //投稿日
    @IBOutlet weak var postDate: UILabel!
    //特産品名
    @IBOutlet weak var specialtyName: UILabel!
    //評価
    @IBOutlet weak var evaluation: UILabel!
    //コメント
    @IBOutlet weak var comment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
