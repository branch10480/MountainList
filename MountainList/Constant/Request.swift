//
//  Request.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/21.
//

import Foundation

extension URLRequest {
    static var getMountains: URL {
        return URL(string: "https://s3-ap-northeast-1.amazonaws.com/file.yamap.co.jp/ios/mountains.json")!
    }
}
