//
//  UrlTableViewCell.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/17.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class ListDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var urlTitle: UILabel!
    
    @IBOutlet weak var urlCreatedAt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        url.textColor = UIColor.hexStr(type: .textLight, alpha: 1.0)
        
    }
    
}
