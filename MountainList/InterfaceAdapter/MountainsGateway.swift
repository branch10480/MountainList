//
//  MountainsGateway.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import Foundation
import RxSwift
import Alamofire

protocol MountainsGatewayProtocol {
    /// 山情報の取得を行う
    func fetch() -> Single<MountainStatusList>
    /// いいね！情報を保存する
    func save(like: Bool, for id: Mountain.ID) -> Single<Void>
}

final class MountainsGateway: MountainsGatewayProtocol {

    var webClient: WebClientProtocol!
    
    func fetch() -> Single<MountainStatusList> {
        return webClient.fetch()
    }
    
    func save(like: Bool, for id: Mountain.ID) -> Single<Void> {
        return webClient.save(like: like, for: id)
    }
}

