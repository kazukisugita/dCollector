//
//  color.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/15.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import Foundation

enum Colors {
    case textBlack
    case grayBack
    case littleGray
    case blue1
    case textLight
    case defaultBackground
    // v2
    case navHeader
    case textBlack_v2
    case textBlack_light_v2
    case shadow
}

extension UIColor {
    
    // UIColor.hexStr("34495e", alpha: 1)
    
    class func hexStr ( type : Colors, alpha : CGFloat) -> UIColor {
        
        var hexStr: NSString
        
        switch type {
        case .littleGray:
            hexStr = "FCFCFC"
        case .textBlack:
            hexStr = "4E4E4E"
        case .grayBack:
            hexStr = "E8E8E8"
        case .blue1:
            hexStr = "4D98FF"
        case .textLight:
            hexStr = "4E4E4E"
        case .defaultBackground:
            hexStr = "EFEFF4"
        // v2
        case .navHeader:
            hexStr = "0087EC"
        case .textBlack_v2:
            hexStr = "444444"
        case .textBlack_light_v2:
            hexStr = "CCCCCC"
        case .shadow:
            hexStr = "000000"
        }
        
        let alpha = alpha
        hexStr = hexStr.replacingOccurrences(of: "#", with: "") as NSString
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.white;
        }
    }
}


