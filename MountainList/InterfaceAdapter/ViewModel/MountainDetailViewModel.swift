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
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMsgDidReceived = PublishRelay<String>()
    
    private var id: Mountain.ID!
    private let useCase: MountainsUseCaseProtocol!
    private let disposeBag = DisposeBag()
    
    init(useCase: MountainsUseCaseProtocol, id: Mountain.ID) {
        self.useCase = useCase
        self.id = id
    }
    
}
