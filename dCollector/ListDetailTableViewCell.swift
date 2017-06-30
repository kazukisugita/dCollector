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
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var urlCreatedAt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        url.textColor = UIColor.hexStr(type: .textBlack_light_v2, alpha: 1.0)
        urlTitle.textColor = UIColor.hexStr(type: .textBlack_v2, alpha: 1.0)
        
        containerView.clipsToBounds = false
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowColor = UIColor.hexStr(type: .shadow, alpha: 1.0).cgColor
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.16
    }
    
}
