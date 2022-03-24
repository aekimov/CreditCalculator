//
//  MainCoordinator.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 01/14/21.
//

import UIKit
// MARK: - Delegate

protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidFinish(_ coordinator: MainCoordinator)
}

// MARK: - Coordinator

final class MainCoordinator: NavigationCoordinator {
    weak var delegate: MainCoordinatorDelegate?

    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: UIViewController
    
    private let creditsViewController: CreditsViewController

    init(navigator: NavigatorType) {
        self.navigator = navigator
        let viewModel = CreditsViewModel()
        self.creditsViewController = CreditsViewController(viewModel: viewModel)
        self.rootViewController = creditsViewController
        
        navigator.setRootViewController(rootViewController, animated: true)
    }

    func start() {
        childCoordinators.forEach { $0.start() }
        creditsViewController.delegate = self
    }
}

extension MainCoordinator: CreditsViewControllerDelegate {
    
    func didTapSettingsButton(_ controller: CreditsViewController) {
        
        let viewController = SettingsViewController()
        viewController.delegate = self
        navigator.push(viewController, animated: true)
    }
    
    func showCredit(_ controller: CreditsViewController, section: Int) {
        
        let model = controller.viewModel.credits[section]
        let calculator = Calculator(creditModel: model)
        let viewModel = DetailViewModel(calculator: calculator, section: section)
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.delegate = self
        navigator.push(viewController, animated: true)
    }

    func didTapAddCreditButton(_ controller: CreditsViewController) {
        
        let model = CreditModel(title: "", amount: 0, period: 0, rate: 0, zeroDate: 0)
        let viewModel = InputViewModel(model: model)
        let viewController = InputViewController(viewModel: viewModel)
        viewController.delegate = self
        navigator.push(viewController, animated: true)
    }
}

extension MainCoordinator: SettingsViewControllerDelegate {
    func didSelectRow(_ controller: SettingsViewController, indexPath: IndexPath) {
        let viewController = SupportViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        controller.present(navigationController, animated: true)
    }
}


extension MainCoordinator: DetailViewControllerDelegate {

    func didTapEditPayment(_ controller: DetailViewController, section: Int, selectedEarlyPayment: EarlyPaymentModel) {
        
        let selectedPaymentDate = selectedEarlyPayment.date
        
        let model = controller.viewModel.modelWithoutSpecificPayment(dateDouble: selectedPaymentDate)
        
        let calculator = Calculator(creditModel: model)
        let viewModel = ChangePaymentViewModel(calculator: calculator, section: section, selectedEarlyPayment: selectedEarlyPayment)
        let viewController = ChangePaymentViewController(viewModel: viewModel)
        
        navigator.push(viewController, animated: true)
    }
    
    func didTapAddPayment(_ controller: DetailViewController, section: Int) {
        let model = controller.viewModel.updatedCredit
        let calculator = Calculator(creditModel: model)
        let viewModel = AddPaymentViewModel(calculator: calculator, section: section)
        let viewController = AddPaymentViewController(viewModel: viewModel)
        
        viewController.delegate = self
        navigator.push(viewController, animated: true)
    }
    
    func didTapShowScheduleButton(_ controller: DetailViewController, section: Int) {
        
        let model = DataManager().fetchCreditsUD()[section]
        let calculator = Calculator(creditModel: model)
        
        let viewModel = PaymentsViewModel(calculator: calculator)
        let viewController = PaymentsViewController(viewModel: viewModel)
  
        navigator.push(viewController, animated: true)
    }
    
    func didTapDeleteButton(_ controller: DetailViewController) {

        controller.showAlert(title: Localized.alertDeleteCredit, message: Localized.alertMessage, cancelTitle: "Cancel", actionTitle: "Delete") { alertAction in
            
            switch alertAction {
            case .cancel:
                controller.dismiss(animated: true)
            case .delete:
                controller.viewModel.deleteCredit()
                controller.dismiss(animated: true)
                self.navigator.popToRootViewController(animated: true)
            }
        }
    }
    
    func didTapEditButton(_ controller: DetailViewController) {
        
        let section = controller.viewModel.section
        let dataManager = DataManager()
        let creditsArray = dataManager.fetchCreditsUD()
        let model = creditsArray[section]
        ///добавил замыкание, чтобы тянуть обновленные данные в DetailViewController, а затем в DetailViewModel 
        let viewModel = EditViewModel(model: model, dataManager: dataManager, section: section) { [weak controller] creditModel in
            controller?.callback(creditModel: creditModel)
        }
        let viewController = EditViewController(viewModel: viewModel)
        viewController.delegate = self
        controller.present(viewController, animated: true)
    }
}

extension MainCoordinator: EditViewControllerDelegate {
    func didTapSaveButton(_ controller: EditViewController) {
        controller.dismiss(animated: true)
    }
}


extension MainCoordinator: InputViewControllerDelegate {
    func didTapSaveButton(_ controller: InputViewController) {
        navigator.popToRootViewController(animated: true)
    }
    
    func didTapCalculateButton(_ controller: InputViewController) {
        
        let model = controller.viewModel.newCredit
        let calculator = Calculator(creditModel: model)

        let viewModel = PaymentsViewModel(calculator: calculator)
        let viewController = PaymentsViewController(viewModel: viewModel)

        navigator.push(viewController, animated: true)
    }
}


extension MainCoordinator: AddPaymentViewControllerDelegate {
    func AddPaymentDidTapButton(_ controller: AddPaymentViewController) {
        
    }
}
