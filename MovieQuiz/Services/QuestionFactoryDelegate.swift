//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-11-25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
