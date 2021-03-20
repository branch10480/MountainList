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
    private let hasFetchedMountains = BehaviorRelay<Bool>(value: false)
    
    init(
        useCase: MountainsUseCaseProtocol,
        viewWillAppear: Observable<Void>
    ) {
        self.useCase = useCase
        self.refresh()
        
        self.subscribeViewWillAppear(viewWillAppear)
    }
    
    private func subscribeViewWillAppear(_ observable: Observable<Void>) {
        observable
            .withLatestFrom(hasFetchedMountains.asObservable())
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.refreshLocally()
            })
            .disposed(by: disposeBag)
    }
    
    private func refresh() {
        isLoading.accept(true)
        self.useCase.fetch()
            .subscribe(
                onSuccess: { [weak self] statuses in
                    self?.setSections(from: statuses)
                    self?.hasFetchedMountains.accept(true)
                    self?.isLoading.accept(false)
                },
                onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMsgDidReceived.accept(error.localizedDescription)
                })
            .disposed(by: disposeBag)
    }
    
    private func refreshLocally() {
        useCase.fetchLocally()
            .subscribe(onSuccess: { [weak self] statuses in
                self?.setSections(from: statuses)
            })
            .disposed(by: disposeBag)
    }
    
    private func setSections(from statuses: [MountainStatus]) {
        let cellViewDataList = Array(mountainsStatuses: statuses)
        let sections = [
            MountainListSectionModel(
                model: .mountains,
                items: cellViewDataList.map{ MountainListSectionItem.mountain($0) })
        ]
        self.sections.accept(sections)
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
