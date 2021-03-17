//
//  Transitioner.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/17.
//

import Foundation
import UIKit

protocol Transitioner where Self: UIViewController {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool)
    func popToRootViewController(animated: Bool)
    func popToViewController(_ viewController: UIViewController, animated: Bool)
    func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)?
    )
    func dismiss(animated: Bool)
}

// デフォルト実装
extension Transitioner {
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let nc = navigationController else { return }
        nc.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        guard let nc = navigationController else { return }
        nc.popViewController(animated: animated)
    }
    
    func popToRootViewController(animated: Bool) {
        guard let nc = navigationController else { return }
        nc.popToRootViewController(animated: animated)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool) {
        guard let nc = navigationController else { return }
        nc.popToViewController(viewController, animated: true)
    }
    
    func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)?
    ) {
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func dismiss(animated: Bool) {
        dismiss(animated: animated)
    }
}
