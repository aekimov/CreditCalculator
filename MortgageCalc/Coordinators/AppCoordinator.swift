//
//  AppCoordinator.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 01/14/21.
//


import UIKit

final class AppCoordinator: PresentationCoordinator {

    var childCoordinators: [Coordinator] = []
    
    private let navigator: NavigatorType
    
    private var navigationController = UINavigationController()
    
    var rootViewController : UIViewController {
        return navigationController
    }
    
    init() {
        self.navigator = Navigator(navigationController: navigationController)
    }

    func start() {
        
        let mainCoordinator = MainCoordinator(navigator: navigator)
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
        mainCoordinator.delegate = self
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidFinish(_ coordinator: MainCoordinator) {
        dismissCoordinator(coordinator, animated: true)
    }
}
