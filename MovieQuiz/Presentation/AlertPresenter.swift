//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-11-26.
//

import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
  
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { [weak self] _ in
                self?.delegate?.didDismissAlert()
            }
        
        let actionReset = UIAlertAction(
            title: model.resetButtonText,
            style: .default ) { [weak self] _ in
                self?.statisticService.resetScore()
                self?.delegate?.didDismissAlert()
            }
        
        alert.addAction(action)
        alert.addAction(actionReset)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
