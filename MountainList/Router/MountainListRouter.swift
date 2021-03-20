//
//  MountainListRouter.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/17.
//

import Foundation
import UIKit

protocol MountainListViewProtocol: Transitioner {}

protocol MountainListRouterProtocol {
    func transitionToMountainDetail(id: Mountain.ID)
}

final class MountainListRouter: MountainListRouterProtocol {
    
    private(set) weak var view: MountainListViewProtocol!
    
    init(view: MountainListViewProtocol) {
        self.view = view
    }

    func transitionToMountainDetail(id: Mountain.ID) {
        let vc = MountainDetailViewController()
        vc.mountainId = id
        let router = MountainDetailRouter(view: vc)
        vc.router = router
        view.pushViewController(vc, animated: true)
    }
}
