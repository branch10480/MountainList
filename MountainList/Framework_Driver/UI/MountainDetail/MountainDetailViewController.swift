//
//  MountainDetailViewController.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import UIKit
import RxSwift

struct MountainDetailViewData1 {
    let name: String
    let location: String
    let elevation: String
    let isLike: Bool
    let likeCount: String
    let mainImage: String
    let description: String
}

struct MountainDetailViewData2 {
    struct Mountain {
        let image: String
        let name: String
    }
    let recommendedMountains: [MountainDetailViewData2.Mountain]
}

class MountainDetailViewController: UIViewController, MountainDetailViewProtocol {
    
    var mountainId: Mountain.ID!
    private lazy var viewModel: MountainDetailViewModel = MountainDetailViewModel(
        useCase: Application.shared.useCase, id: mountainId,
        likeButtonTap: likeButton.rx.tap.asObservable()
    )
    var router: MountainDetailRouterProtocol!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var likeTextLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var recommendationTitleLabel: UILabel!
    @IBOutlet var recommendedMountainImageViews: [UIImageView]!
    @IBOutlet var recommendedMountainNameLabels: [UILabel]!
    @IBOutlet weak var likeButton: RoundLikeButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    private func setup() {
        title = "MountainDetailViewController.title".localized
        likeTextLabel.text = "MountainDetailViewController.likeTextLabel.text".localized
        recommendationTitleLabel.text =
            "MountainDetailViewController.recommendationTitleLabel.text".localized
    }
    
    private func bind() {
        viewModel.isLoading.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] loading in
                self?.setHUD(visible: loading)
            })
            .disposed(by: disposeBag)
        
        viewModel.viewData1
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.apply(data)
            })
            .disposed(by: disposeBag)
        
        viewModel.viewData2
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.apply(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func apply(_ viewData: MountainDetailViewData1?) {
        guard let viewData = viewData else {
            return
        }
        nameLabel.text = viewData.name
        locationLabel.text = viewData.location
        elevationLabel.text = viewData.elevation
        likeCountLabel.text = viewData.likeCount
        if let url = URL(string: viewData.mainImage) {
            mainImageView.sd_setImage(with: url, completed: nil)
        }
        descriptionTextView.text = viewData.description
        updateLikeStatus(getLiked: viewData.isLike)
    }
    
    private func apply(_ viewData: MountainDetailViewData2?) {
        showRecommendedMountains(viewData)
    }
    
    private func updateLikeStatus(getLiked: Bool) {
        likeButton.updateStatus(getLiked: getLiked)
        if getLiked {
            likeTextLabel.textColor = .likeActiveColor
            likeCountLabel.textColor = .likeActiveColor
        } else {
            likeTextLabel.textColor = .likeNormalColor
            likeCountLabel.textColor = .likeNormalColor
        }
    }
    
    private func showRecommendedMountains(_ viewData: MountainDetailViewData2?) {
        let recommendedList = viewData?.recommendedMountains
        // 初期化
        recommendedMountainImageViews.forEach { imageView in
            imageView.image = nil
        }
        recommendedMountainNameLabels.forEach { label in
            label.text = ""
        }
        // 表示
        recommendedList?.enumerated().forEach { (index, data) in
            let imageView = recommendedMountainImageViews[index]
            let label = recommendedMountainNameLabels[index]
            if let url = URL(string: data.image) {
                imageView.sd_setImage(with: url, completed: nil)
                label.text = data.name
            }
        }
    }

}
