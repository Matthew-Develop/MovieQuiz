//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-11-26.
//

import UIKit

struct AlertModel {
    var title: String = "Этот раунд окончен!"
    var message: String
    var buttonText: String = "Сыграть еще раз"
    var completion: () -> Void
}

