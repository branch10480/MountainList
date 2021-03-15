//
//  MountainListUseCase.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation
import RxSwift

/// Interface Adapter へ公開するインタフェース
protocol MountainListUseCaseProtocol {
    /// 山情報一覧を取得
    func fetch() -> Single<[MountainStatus]>
    /// いいね！登録
    func set(like: Bool, for mountain: Mountain.ID) -> Single<Void>

    // 外部オブジェクト
    var mountainsGateway: MountainsGatewayProtocol! { get set }
}

final class MountainListUseCase: MountainListUseCaseProtocol {
    
    var mountainsGateway: MountainsGatewayProtocol!
    
    private var statusList = MountainStatusList(mountains: [])
    
    func fetch() -> Single<[MountainStatus]> {
        return Single<[MountainStatus]>.create { [weak self] observer in
            
            self?.mountainsGateway.fetch { [weak self] result in
                switch result {
                case .success(let mountains):
                    let statusList = MountainStatusList(mountains: mountains)
                    self?.statusList = statusList
                    observer(.success(statusList.statuses))
                case .failure(let e):
                    observer(.error(e))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func set(like: Bool, for mountain: Mountain.ID) -> Single<Void> {
        return Single<Void>.create { [weak self] observer in
            
            self?.mountainsGateway.save(like: like, for: mountain, completion: { result in
                switch result {
                case .success:
                    observer(.success(()))
                case .failure(let e):
                    observer(.error(e))
                }
            })
            
            return Disposables.create()
        }
    }
    
}
