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
        useCase.get(id: id).subscribe(onSuccess: { [weak self] status in
            guard let status: MountainStatus = status,
                  let self = self
            else {
                return
            }
            self.viewData1.accept(self.convert(from: status))
        }, onError: { e in
            
        })
        .disposed(by: disposeBag)
    }
    
    private func convert(from status: MountainStatus) -> MountainDetailViewData1 {
        
        let mountain = status.mountain
        let data = MountainDetailViewData1(
            name: mountain.name,
            location: mountain.prefectures.joined(separator: " / "),
            elevation: String(format: "%.2f m", mountain.elevation),
            isLike: status.isLiked,
            likeCount: mountain.likeCount.description,
            mainImage: mountain.imageUrl,
            description: mountain.description
        )
        return data
    }
    
}

fileprivate extension MountainStatus {
    var convertToData1: MountainDetailViewData1 {
        let status = self
        let mountain = status.mountain
        let data = MountainDetailViewData1(
            name: mountain.name,
            location: mountain.prefectures.joined(separator: " / "),
            elevation: String(format: "%.2f m", mountain.elevation),
            isLike: status.isLiked,
            likeCount: status.likeCount.description,
            mainImage: mountain.imageUrl,
            description: mountain.description
        )
        return data
    }
}
