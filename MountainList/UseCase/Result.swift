//
//  Result.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
