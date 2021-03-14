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
    func fetch() -> Single<MountainStatusList>
    /// いいね！登録
    func set(like: Bool, for mountain: Mountain.ID) -> Single<Void>

    // 外部オブジェクト
    var mountainsGateway: MountainsGatewayProtocol { get set }
}

final class MountainListUseCase {
    
    var mountainsGateway: MountainsGatewayProtocol!
    
    func fetch() -> Single<MountainStatusList> {
        return mountainsGateway.fetch()
    }
    
    func set(like: Bool, for mountain: Mountain.ID) -> Single<Void> {
        return mountainsGateway.save(like: like, for: mountain)
    }
    
}
