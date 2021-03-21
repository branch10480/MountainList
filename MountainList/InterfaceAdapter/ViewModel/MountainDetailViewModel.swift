//
//  MountainDetailViewModel.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/17.
//

import Foundation
import RxSwift
import RxRelay

final class MountainDetailViewModel {
    
    var viewData1 = BehaviorRelay<MountainDetailViewData1?>(value: nil)
    var viewData2 = BehaviorRelay<MountainDetailViewData2?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMsgDidReceived = PublishRelay<String>()
    
    private var id: Mountain.ID!
    private let useCase: MountainsUseCaseProtocol!
    private let disposeBag = DisposeBag()
    private let maxCountOfRecommendation: Int = 2
    
    init(
        useCase: MountainsUseCaseProtocol,
        id: Mountain.ID,
        likeButtonTap: Observable<Void>
    ) {
        self.useCase = useCase
        self.id = id
        
        let isLikeObservable = viewData1.map { $0?.isLike }
        likeButtonTap.withLatestFrom(isLikeObservable)
            .subscribe(onNext: { [weak self] currentLikeStatus in
                guard let self = self,
                      let currentLikeStatus = currentLikeStatus
                else {
                    return
                }
                self.isLoading.accept(true)
                self.useCase.set(like: !currentLikeStatus, for: self.id)
                    .subscribe(onSuccess: { [weak self] statuses in
                        if let status = statuses.first(
                            where: { mountain in mountain.mountain.id == id })
                        {
                            self?.viewData1.accept(status.convertToData1)
                        }
                        self?.isLoading.accept(false)
                    }, onError: { [weak self] e in
                        self?.errorMsgDidReceived.accept(e.localizedDescription)
                        self?.isLoading.accept(false)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        refresh()
    }
    
    private func refresh() {
        isLoading.accept(true)
        useCase.get(id: id).subscribe(onSuccess: { [weak self] status in
            guard let status: MountainStatus = status,
                  let self = self
            else {
                return
            }
            self.viewData1.accept(status.convertToData1)
            self.isLoading.accept(false)
            
            // おすすめの山情報取得
            self.fetchRecommendedMountains(with: self.id)

        }, onError: { [weak self] e in
            self?.errorMsgDidReceived.accept(e.localizedDescription)
            self?.isLoading.accept(false)
        })
        .disposed(by: disposeBag)
    }
    
    private func fetchRecommendedMountains(with id: Mountain.ID) {
        isLoading.accept(true)
        useCase.getRecommendedMountains(id: id, maxCount: maxCountOfRecommendation)
            .subscribe(onSuccess: { [weak self] mountains in
                let data = mountains.map {
                    MountainDetailViewData2.Mountain(
                        image: $0.mountain.imageUrl,
                        name: $0.mountain.name
                    )
                }
                self?.viewData2.accept(MountainDetailViewData2(recommendedMountains: data))
                self?.isLoading.accept(false)
            }, onError: { [weak self] e in
                self?.errorMsgDidReceived.accept(e.localizedDescription)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
}

fileprivate extension MountainStatus {
    var convertToData1: MountainDetailViewData1 {
        let status = self
        let mountain = status.mountain
        let data = MountainDetailViewData1(
            name: mountain.name,
            location: mountain.prefectures.joined(separator: " / "),
            elevation: String(format: "elevation".localized, mountain.elevation),
            isLike: status.isLiked,
            likeCount: status.likeCount.description,
            mainImage: mountain.imageUrl,
            description: mountain.description
        )
        return data
    }
}
