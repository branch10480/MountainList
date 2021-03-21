//
//  Application.swift
//  MountainList
//
//  Created by branch10480 on 2021/03/13.
//

import UIKit

final class Application {
    
    /// Shared Instance.
    static let shared = Application()
    private init() {}
    
    // Use Case.
    private(set) var useCase: MountainListUseCase!
    
    func configure(with window: UIWindow) {
        buildLayer()
        
        // Use Case.
        useCase = MountainListUseCase()
        
        // Interface Adapter.
        let mountainsGateway = MountainsGateway()
        useCase.mountainsGateway = mountainsGateway
        
        // Framework, Driver.
        let mountainsRepository = MountainRepository()
//        let mountainsRepository = MountainRepositoryStub()
        mountainsGateway.webClient = mountainsRepository
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = sb.instantiateInitialViewController()
    }
    
    private func buildLayer() {
        
    }
}
