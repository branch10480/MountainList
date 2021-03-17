//
//  MountainListViewModel.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

final class MountainListViewModel {
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var sections = BehaviorRelay<[MountainListSectionModel]>(value: [])
    var errorMsgDidReceived = PublishRelay<String>()
    
    private let useCase: MountainsUseCaseProtocol!
    private let disposeBag = DisposeBag()
    
    init(useCase: MountainsUseCaseProtocol) {
        self.useCase = useCase
        
        isLoading.accept(true)
        self.useCase.fetch()
            .subscribe(
                onSuccess: { [weak self] statuses in
                    let cellViewDataList = Array(mountainsStatuses: statuses)
                    let sections = [
                        MountainListSectionModel(
                            model: .mountains,
                            items: cellViewDataList.map{ MountainListSectionItem.mountain($0) })
                    ]
                    self?.sections.accept(sections)
                    self?.isLoading.accept(false)
                },
                onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMsgDidReceived.accept(error.localizedDescription)
                })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - RxDataSources

typealias MountainListSectionModel =
    AnimatableSectionModel<MountainListSectionId, MountainListSectionItem>

enum MountainListSectionId: String, IdentifiableType {
    
    case mountains = "mountain"
    
    var identity: String {
        return rawValue
    }
}

enum MountainListSectionItem: IdentifiableType, Equatable {
    
    case mountain(_ viewData: MountainCellViewData)
    
    var identity: String {
        switch self {
        case .mountain(let viewData):
            return viewData.id
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.mountain(let lhsData), .mountain(let rhsData)):
            return
                lhsData.id == rhsData.id &&
                lhsData.name == rhsData.name &&
                lhsData.isLike == rhsData.isLike &&
                lhsData.likeCount == rhsData.likeCount
        }
    }
}
