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
    
    func showAlertResults(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
  
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        
        let actionReset = UIAlertAction(
            title: model.resetButtonText,
            style: .default ) { [weak self ] _ in
                model.completion()
                self?.statisticService.resetScore()
            }
        
        alert.addAction(action)
        alert.addAction(actionReset)
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func showAlertError(model: AlertModelError) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
