//
//  Mountain.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import Foundation

struct Mountain: Equatable, Codable {
    struct ID: RawRepresentable, Hashable, Codable {
        let rawValue: Int
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
    
    var isLikeBool: Bool {
        switch isLike {
        case "true":
            return true
        default:
            return false
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
