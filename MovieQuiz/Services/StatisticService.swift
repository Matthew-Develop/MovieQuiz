//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-12-01.
//

import UIKit

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case totalCorrectAnswers
        case totalQuestions
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case gamesCount
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        } set {
            storage.setValue(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        } set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestions: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.totalQuestions.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            if let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date {
                return GameResult(
                    correct: correct,
                    total: total,
                    date: date)
            } else {
                return GameResult(
                    correct: correct,
                    total: total,
                    date: Date())
            }
        } set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if gamesCount == 0 {
            0.00
        } else {
            Double(totalCorrectAnswers) / Double(totalQuestions) * 100.00
        }
    }
    
    func store(game: GameResult) {
        gamesCount += 1
        totalCorrectAnswers += game.correct
        totalQuestions += game.total
        
        if gamesCount == 1 {
            bestGame = game
        }
        if game.isBetterThan(bestGame) {
            bestGame = game
        }
    }
    
    func resetScore() {
        let allValues = UserDefaults.standard.dictionaryRepresentation()
        
        for (key, _) in allValues {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
