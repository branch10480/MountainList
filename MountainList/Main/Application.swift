//
//  Application.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import UIKit

final class Application {
    
    /// Shared Instance.
    static let shared = Application()
    private init() {}
    
    // Use Case.
    
    func configure(with window: UIWindow) {
        buildLayer()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = sb.instantiateInitialViewController()
    }
    
    private func buildLayer() {
        
    }
}
