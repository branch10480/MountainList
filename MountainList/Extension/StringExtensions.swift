//
//  StringExtensions.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import Foundation

extension String {
    
    /// Localized string by Localizable.string.
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
