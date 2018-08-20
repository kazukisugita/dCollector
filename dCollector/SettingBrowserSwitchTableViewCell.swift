//
//  MoreBrowserSwitchTableViewCell.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/07/04.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit


class SettingBrowserSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var browserImage: UIImageView!
    @IBOutlet weak var browserImageTrailing: NSLayoutConstraint!
    @IBOutlet weak var segment: UISegmentedControl!
    
    fileprivate let browserIcons: [UIImage] = [#imageLiteral(resourceName: "browser-default"), #imageLiteral(resourceName: "browser-safari"), #imageLiteral(resourceName: "browser-chrome")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.text = "Browser that opens the URL is".localized()
        if UIApplication.shared.canOpenURL(URL(string:"googlechrome://")!) == false {
            segment.setEnabled(false, forSegmentAt: 2)
        }
        segment.selectedSegmentIndex = AppSettings.broswerIs()
        browserImage.image = browserIcons[AppSettings.broswerIs()]
    }
    

    @IBAction func segmentChanged(_ sender: Any) {
        
        let seg = sender as! UISegmentedControl
        let index = seg.selectedSegmentIndex
        
        AppSettings.changeBrowserIs(index: index)
        browserImageAnimate(index: index)
    }
    
    
    private func browserImageAnimate(index: Int) {
        
        self.layoutIfNeeded()
        browserImage.image = browserIcons[index]
        browserImage.alpha = 0.0
        self.browserImageTrailing.constant += 12.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
            self.layoutIfNeeded()
            self.browserImage.alpha = 1.0
            self.browserImageTrailing.constant = 24.0
        }, completion: { _ in
            self.browserImageTrailing.constant = 24.0
        })
    }
    
}
