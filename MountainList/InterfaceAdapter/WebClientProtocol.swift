//
//  WebClientProtocol.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import Foundation

protocol MountainRepositoryProtocol {
    func fetch(completion: @escaping (Result<[Mountain]>) -> Void)
    func save(
        like: Bool,
        for id: Mountain.ID,
        completion: @escaping (Result<Void>) -> Void)
}

