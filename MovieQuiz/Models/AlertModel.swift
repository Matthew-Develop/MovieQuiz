//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-11-26.
//

import UIKit

struct AlertModel {
    let title: String = "Этот раунд окончен!"
    let message: String
    let buttonText: String = "Сыграть еще раз"
    let resetButtonText: String = "Сбросить статистику"
    let completion: (()->Void)
}

struct AlertModelError {
    let title: String
    let message: String
    let buttonText: String
    let completion: (()->Void)
}
