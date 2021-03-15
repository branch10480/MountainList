//
//  MountainListViewController.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import UIKit
import JGProgressHUD
import RxSwift

class MountainListViewController: UIViewController {
    
    private var viewModel: MountainListViewModel!
    private let disposeBag = DisposeBag()
    private let hud = JGProgressHUD()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let useCase: MountainListUseCaseProtocol = Application.shared.useCase
        self.viewModel = MountainListViewModel(useCase: useCase)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    private func setup() {
        title = "MountainListView.title".localized
    }
    
    private func bind() {
        viewModel.isLoading.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.setHUD(visible: loading)
            })
            .disposed(by: disposeBag)
    }
    
    private func setHUD(visible: Bool) {
        if visible {
            hud.show(in: view)
        } else {
            hud.dismiss()
        }
    }

}
