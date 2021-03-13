//
//  Mountain.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import Foundation

struct Mountain: Equatable, Codable {
    struct ID: RawRepresentable, Hashable, Codable {
        let rawValue: String
    }
    let id: ID
    let name: String
    let description: String
    let thumbnailUrl: String
    let imageUrl: String
    let elevation: Double
    let latitude: Double
    let longitude: Double
    let prefectures: [String]
    let areaId: Int
    let likeCount: Int
    let isLike: String
    let activityCount: Int
    let viewCount: Int
    let difficultyLevel: Int
    let physicalLevel: Int
}
