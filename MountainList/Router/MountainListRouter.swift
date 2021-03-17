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
    
    private(set) weak var view: Transitioner!
    
    init(view: MountainListViewProtocol) {
        self.view = view
    }

    func transitionToMountainDetail(id: Mountain.ID) {
        let vc = MountainDetailViewController()
        let viewModel = MountainDetailViewModel(
            useCase: Application.shared.useCase,
            id: id
        )
        vc.viewModel = viewModel
        view.pushViewController(vc, animated: true)
    }
}
