//
//  WebClientProtocol.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import Foundation
import RxSwift

protocol WebClientProtocol {
    func fetch() -> Single<MountainStatusList>
    func save(like: Bool, for id: Mountain.ID) -> Single<Void>
}

