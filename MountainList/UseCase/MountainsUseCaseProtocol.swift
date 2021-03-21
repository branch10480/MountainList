//
//  MountainsUseCaseProtocol.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation
import RxSwift

/// Interface Adapter へ公開するインタフェース
protocol MountainsUseCaseProtocol {
    /// 山情報一覧を取得
    func fetch() -> Single<[MountainStatus]>
    /// 山情報一覧を取得（通信をしない）
    func fetchLocally() -> Single<[MountainStatus]>
    /// 山情報を取得
    func get(id: Mountain.ID) -> Single<MountainStatus?>
    /// おすすめの山情報を取得
    func getRecommendedMountains(id: Mountain.ID, maxCount: Int) -> Single<[MountainStatus]>
    /// いいね！登録
    func set(like: Bool, for mountain: Mountain.ID) -> Single<[MountainStatus]>

    // 外部オブジェクト
    var mountainsGateway: MountainsGatewayProtocol! { get set }
}

final class MountainListUseCase: MountainsUseCaseProtocol {
    
    var mountainsGateway: MountainsGatewayProtocol!
    
    private var statusList = MountainStatusList(mountains: [])
    
    func fetch() -> Single<[MountainStatus]> {
        return Single<[MountainStatus]>.create { [weak self] observer in
            
            self?.mountainsGateway.fetch { [weak self] result in
                switch result {
                case .success(let mountains):
                    let statusList = MountainStatusList(mountains: mountains)
                    self?.statusList = statusList
                    observer(.success(statusList.statuses))
                case .failure(let e):
                    observer(.error(e))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func fetchLocally() -> Single<[MountainStatus]> {
        return Single<[MountainStatus]>.create { [weak self] observer in
            observer(.success(self?.statusList.statuses ?? []))
            return Disposables.create()
        }
    }
    
    func get(id: Mountain.ID) -> Single<MountainStatus?> {
        return Single<MountainStatus?>.create { [weak self] observer in
            if let mountain = self?.statusList[id] {
                observer(.success(mountain))
            } else {
                observer(.success(nil))
            }
            return Disposables.create()
        }
    }
    
    func getRecommendedMountains(id: Mountain.ID, maxCount: Int) -> Single<[MountainStatus]> {
        return Single<[MountainStatus]>.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            // 第1条件: エリアIDが等しい
            // 第2条件: いいね数が多い
            // 第3条件: アクティビティ数が多い
            let sorted: [MountainStatus] = self.statusList.statuses.sorted(by: { s1, s2 in
                if s1.likeCount == s2.likeCount {
                    return s1.mountain.activityCount > s2.mountain.activityCount
                } else {
                    return s1.likeCount > s2.likeCount
                }
            })
            var equalIdMountains: [MountainStatus] = []
            var notEqualIdMountains: [MountainStatus] = []
            for status in sorted {
                if status.mountain.id == id {
                    equalIdMountains.append(status)
                } else {
                    notEqualIdMountains.append(status)
                }
            }
            var candidates: [MountainStatus] = equalIdMountains + notEqualIdMountains
            
            // 対象の山情報を削除
            candidates.removeAll(where: { s in s.mountain.id == id })
            
            var recommendedMountains: [MountainStatus] = []
            var index = 0
            while index < maxCount, index < candidates.count {
                recommendedMountains.append(candidates[index])
                index += 1
            }
            observer(.success(recommendedMountains))
            return Disposables.create()
        }
    }
    
    func set(like: Bool, for mountain: Mountain.ID) -> Single<[MountainStatus]> {
        return Single<[MountainStatus]>.create { [weak self] observer in
            
            self?.mountainsGateway.save(like: like, for: mountain, completion: { [weak self] result in
                switch result {
                case .success:
                    guard let self = self else {
                        return
                    }
                    do {
                        try self.statusList.set(isLike: like, for: mountain)
                        observer(.success(self.statusList.statuses))
                    } catch(let e) {
                        observer(.error(e))
                    }
                case .failure(let e):
                    observer(.error(e))
                }
            })
            
            return Disposables.create()
        }
    }
    
}
