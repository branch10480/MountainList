//
//  MountainListViewController.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import UIKit

class MountainListViewController: UIViewController {
    
    private lazy var viewModel: MountainListViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    private func setup() {
        title = "MountainListView.title".localized
    }
    
    private func bind() {
        
    }

}
