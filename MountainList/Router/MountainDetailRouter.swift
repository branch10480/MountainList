//
//  MountainDetailRouter.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/17.
//

import Foundation
import UIKit

protocol MountainDetailViewProtocol: Transitioner {}

protocol MountainDetailRouterProtocol {
    func transitionPop()
}

final class MountainDetailRouter: MountainDetailRouterProtocol {
    
    private(set) weak var view: MountainDetailViewProtocol!
    
    init(view: MountainDetailViewProtocol) {
        self.view = view
    }

    func transitionPop() {
        view.popViewController(animated: true)
    }
}
