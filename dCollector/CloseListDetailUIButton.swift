//
//  CloseListDetailUIButton.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2018/05/12.
//  Copyright © 2018年 Kazuki Sugita. All rights reserved.
//

import UIKit

class CloseListDetailUIButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func toggleVisible(bool: Bool) {
        if (bool == false) {
            self.isHidden = true
        }
    }
    
    func dismissViewController(uiViewController: UIViewController?, completion: (() -> Void)? = nil) {
        guard let vc = uiViewController else { return }
        vc.dismiss(animated: true, completion: completion)
    }
}