//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-11-26.
//

import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
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
                model.completion()
                self?.delegate?.didDismissAlert()
            }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
