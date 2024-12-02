//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-12-01.
//

import UIKit

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(game: GameResult)
    func resetScore()
}


