//
//  TestCollectionViewCell.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/15.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import QuartzCore

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var domainDescription: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    @IBOutlet weak var domainIcon: UIImageView!
    @IBOutlet weak var domainHasUrls: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.hexStr(type: Colors.littleGray, alpha: 1.0)
        self.layer.cornerRadius = 2.0
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = CGSize(width: 0,height: 1)
//        self.layer.shadowRadius = 4
//        
//        self.clipsToBounds = true
//        self.layer.masksToBounds = false
        
//        let shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: 10)
//        self.layer.shadowPath = shadowPath.cgPath
    
    }

}
