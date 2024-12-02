//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-12-01.
//

import UIKit

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
