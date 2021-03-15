//
//  MountainsGateway.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import Foundation
import Alamofire

protocol MountainsGatewayProtocol {
    /// 山情報の取得を行う
    func fetch(completion: @escaping (Result<[Mountain]>) -> Void)
    /// いいね！情報を保存する
    func save(
        like: Bool,
        for id: Mountain.ID,
        completion: @escaping (Result<Void>) -> Void
    )
}

final class MountainsGateway: MountainsGatewayProtocol {
    
    var webClient: MountainRepositoryProtocol!
    
    func fetch(completion: @escaping (Result<[Mountain]>) -> Void) {
        webClient.fetch(completion: completion)
    }
    
    func save(
        like: Bool,
        for id: Mountain.ID,
        completion: @escaping (Result<Void>) -> Void
    ) {
        webClient.save(like: like, for: id, completion: completion)
    }
}

