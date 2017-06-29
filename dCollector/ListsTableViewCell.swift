//
//  ListsTableViewCell.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/17.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class ListsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var domainIcon: UIImageView!
    @IBOutlet weak var domainCount: UILabel!
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        //domainCount.textColor = UIColor.hexStr(type: .blue1, alpha: 1.0)
        domainHost.textColor = UIColor.hexStr(type: .textBlack_light_v2, alpha: 1.0)
        domainTitle.textColor = UIColor.hexStr(type: .textBlack_v2, alpha: 1.0)
        
        containerView.clipsToBounds = false
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowColor = UIColor.hexStr(type: .shadow, alpha: 1.0).cgColor
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.16

        self.accessoryType = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
        if #available(iOS 10, *) {
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse], animations: {
                //self.domainCount.center.x += 10.0
                self.domainCount.alpha = 0.0
            }) { _ in
                //self.domainCount.center.x -= 10.0
                self.domainCount.alpha = 1.0
            }
            
        }
        */
    }
    
}
