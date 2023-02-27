//
//  MainCoordinator.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-26.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let uiFactory: UIFactory

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        uiFactory = UIFactory()
    }

    func start() {
        let controller = uiFactory.makeUsersListViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: false)
    }
    
//    func showDetailViewController() {
//        let controller = uiFactory.makeUserDetailViewController()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
//    }
}
