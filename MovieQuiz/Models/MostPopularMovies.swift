//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Матвей Сюзев on 12/22/24.
//

import UIKit

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
    
    enum CodingKeys: CodingKey {
        case errorMessage, items
    }
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: Double
    let imageURL: URL
    
    var resizedImageURL: URL {
        
        let urlString = imageURL.absoluteString
        
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else { return imageURL}
        
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    
    private enum ParseError: Error {
        case ratingFailure
        case imageURLFailure
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        
        let rating = try container.decode(String.self, forKey: .rating)
        guard let ratingValue = Double(rating) else { throw ParseError.ratingFailure }
        self.rating = ratingValue
        
        let imageURL = try container.decode(String.self, forKey: .imageURL)
        guard let imageURLValue = URL(string: imageURL) else { throw ParseError.imageURLFailure }
        self.imageURL = imageURLValue
    }
}
