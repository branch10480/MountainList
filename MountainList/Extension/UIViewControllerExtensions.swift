//
//  UIViewControllerExtensions.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/20.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    static let hud: JGProgressHUD = JGProgressHUD()

    func setHUD(visible: Bool) {
        if visible {
            Self.hud.show(in: view)
        } else {
            Self.hud.dismiss()
        }
    }
}
