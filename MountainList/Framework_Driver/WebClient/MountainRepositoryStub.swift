//
//  MountainRepositoryStub.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation

final class MountainRepositoryStub: MountainRepositoryProtocol {

    func fetch(completion: @escaping (Result<[Mountain]>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let mountains: [Mountain] = (0..<10).map {
                Mountain(
                    id: .init(rawValue: $0.description),
                    name: "ダミー山 - \($0)", description: "ここに説明文が入ります。ここに説明文が入ります。",
                    thumbnailUrl: "https://tabi-mag.jp/wp-content/uploads/AI007801.jpg",
                    imageUrl: "https://tabi-mag.jp/wp-content/uploads/AI007801.jpg",
                    elevation: 1783.9,
                    latitude: 35.549267,
                    longitude: 138.809209,
                    prefectures: ["岐阜", "長野"],
                    areaId: $0 % 3,
                    likeCount: 3,
                    isLike: $0 % 4 == 0 ? "true" : "false",
                    activityCount: $0 + 100,
                    viewCount: $0 + 10,
                    difficultyLevel: $0 % 3 + 1,
                    physicalLevel: $0 % 3 + 1
                )
            }
            completion(.success(mountains))
        }
    }
    
    func save(like: Bool, for id: Mountain.ID, completion: @escaping (Result<Void>) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(.success(()))
//        }
    }
}
