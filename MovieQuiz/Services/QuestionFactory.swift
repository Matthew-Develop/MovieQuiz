//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 2024-11-24.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "The Godfather", correctAnswer: true),
//        QuizQuestion(
//        image: "The Dark Knight", correctAnswer: true),
//        QuizQuestion(
//        image: "Kill Bill", correctAnswer: true),
//        QuizQuestion(
//        image: "The Avengers", correctAnswer: true),
//        QuizQuestion(
//        image: "Deadpool", correctAnswer: true),
//        QuizQuestion(
//        image: "The Green Knight", correctAnswer: true),
//        QuizQuestion(
//        image: "Old", correctAnswer: false),
//        QuizQuestion(
//        image: "The Ice Age Adventures of Buck Wild", correctAnswer: false),
//        QuizQuestion(
//        image: "Tesla", correctAnswer: false),
//        QuizQuestion(
//        image: "Vivarium", correctAnswer: false),
//    ]
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                
                switch result {
                case .success(let data):
                    self.movies = data.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self ] in
            guard let self = self else { return }
            let index = (0..<movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load Image")
            }
            
            let rating = movie.rating
            
            let questionRating = (4..<10).randomElement() ?? 0
            
            let moreLessRandom = ["больше", "меньше"].randomElement() ?? "больше"
            
            var correctAnswer = false
            var text = ""
            
            if moreLessRandom == "больше" {
                correctAnswer = rating > Double(questionRating)
                text = "Рейтинг этого фильма \(moreLessRandom), чем \(questionRating.description)?"
            } else if moreLessRandom == "меньше" {
                correctAnswer = rating < Double(questionRating)
                text = "Рейтинг этого фильма \(moreLessRandom), чем \(questionRating.description)?"
            }
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [ weak self ] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
//        guard let index = (0..<questions.count).randomElement() else {
//            delegate?.didReceiveNextQuestion(question: nil)
//            return
//        }
//        
//        let question = questions[safe: index]
//        delegate?.didReceiveNextQuestion(question: question)
    }
}
