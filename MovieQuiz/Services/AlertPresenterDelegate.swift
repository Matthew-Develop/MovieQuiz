//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-11-26.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didDismissAlert()
    func didTryLoadDataAgain()
}
