
import UIKit
import Foundation

enum Colors {
    case textBlack
    case grayBack
    case littleGray
    case blue1
    case textLight
    case defaultBackground
}

extension UIColor {
    
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
    
    
    class func hexStrRaw(hex: String, alpha: CGFloat) -> UIColor {
        var hexStr: NSString = hex as NSString
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


