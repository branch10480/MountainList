//
//  MountainListViewModel.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation
import RxSwift
import RxRelay

final class MountainListViewModel {
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMsgDidReceived = PublishRelay<String>()
    
    private let useCase: MountainListUseCaseProtocol!
    private let disposeBag = DisposeBag()
    
    init(useCase: MountainListUseCaseProtocol) {
        self.useCase = useCase
        
        isLoading.accept(true)
        self.useCase.fetch()
            .subscribe(
                onSuccess: { [weak self] statuses in
                    for status in statuses {
                        print(status)
                    }
                    self?.isLoading.accept(false)
                },
                onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMsgDidReceived.accept(error.localizedDescription)
                })
            .disposed(by: disposeBag)
    }
    
}
