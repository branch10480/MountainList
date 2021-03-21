//
//  MountainRepository.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/14.
//

import Foundation
import Alamofire

final class MountainRepository: MountainRepositoryProtocol {

    func fetch(completion: @escaping (Result<[Mountain]>) -> Void) {
        AF.request(URLRequest.getMountains, method: .get, parameters: nil).responseJSON { res in
            switch res.result {
            case .success:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                var data: [Mountain] = []
                if let resData = res.data {
                    do {
                        data = try decoder.decode([Mountain].self, from: resData)
                    } catch(let e) {
                        debugPrint(e)
                    }
                }
                completion(.success(data))
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }
    
    func save(like: Bool, for id: Mountain.ID, completion: @escaping (Result<Void>) -> Void) {
        completion(.success(()))
    }

}
