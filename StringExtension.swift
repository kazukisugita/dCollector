//
//  StringExtension.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/06/11.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import Foundation

extension String {
    public func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
