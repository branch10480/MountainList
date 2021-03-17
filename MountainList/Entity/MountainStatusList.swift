//
//  MountainStatusList.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation

struct MountainStatus: Equatable {
    let mountain: Mountain
    let isLiked: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.mountain == rhs.mountain
    }
}

extension Array where Element == MountainStatus {
    init(mountains: [Mountain]) {
        self = mountains.map { mountain in
            MountainStatus(mountain: mountain, isLiked: mountain.isLike == "true")
        }
    }
}

struct MountainStatusList {
    
    enum Error: Swift.Error {
        case notFoundMountain(ofID: Mountain.ID)
    }
    
    private(set) var statuses: [MountainStatus]
    
    init(mountains: [Mountain], trimmed: Bool = false) {
        statuses = Array(mountains: mountains)
            .unique(resolve: { _, _ in return .ignoreNewOne })
        if trimmed {
            statuses = statuses.filter { $0.isLiked }
        }
    }
    
    mutating func append(mountains: [Mountain]) {
        let newStatusesMayNotUnique = statuses + Array(mountains: mountains)
        statuses = newStatusesMayNotUnique
            .unique(resolve: { _, _ in return .removeOldOne })
    }
    
    mutating func set(isLike: Bool, for id: Mountain.ID) throws {
        guard let index = statuses.firstIndex(where: { status in status.mountain.id == id })
        else {
            throw Error.notFoundMountain(ofID: id)
        }
        let currentStatus = statuses[index]
        statuses[index] = MountainStatus(
            mountain: currentStatus.mountain,
            isLiked: isLike
        )
    }
    
    subscript(id: Mountain.ID) -> MountainStatus? {
        return statuses.first(where: { $0.mountain.id == id })
    }
    
    subscript(id: Int) -> MountainStatus? {
        return statuses[id]
    }
}
