//
//  MountainListViewController.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import UIKit
import JGProgressHUD
import RxSwift
import RxDataSources

class MountainListViewController: UIViewController {

    fileprivate enum CellId {
        static let mountain = "mountainCell"
    }
    private let dataSource = RxTableViewSectionedAnimatedDataSource<MountainListSectionModel>(
        animationConfiguration: AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .fade,
            deleteAnimation: .automatic
        ),
        configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .mountain(let viewData):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellId.mountain,
                    for: indexPath
                ) as! MountainCell
                cell.configure(viewData)
                return cell
            }
        }
    )
    private var viewModel: MountainListViewModel!
    private let disposeBag = DisposeBag()
    private let hud = JGProgressHUD()

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let useCase: MountainListUseCaseProtocol = Application.shared.useCase
        self.viewModel = MountainListViewModel(useCase: useCase)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        DispatchQueue.main.async {
            self.bind()
        }
    }
    
    private func setup() {
        title = "MountainListView.title".localized
        tableView.register(
            UINib(nibName: "MountainCell", bundle: nil),
            forCellReuseIdentifier: CellId.mountain
        )
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        viewModel.isLoading.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.setHUD(visible: loading)
            })
            .disposed(by: disposeBag)
        
        viewModel.sections
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
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

// MARK: - UITableViewDelegate

extension MountainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
