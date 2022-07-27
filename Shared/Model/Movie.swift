//
//  Movie.swift
//  NavigationRouterPractice (iOS)
//
//  Created by Hung-Chun Tsai on 2022-07-26.
//

import Foundation

struct Movie: Identifiable {
    var id = UUID()
    var name: String
    var rate: Double
    var director: String
    var image: String
    
    init(
        name: String,
        rate: Double,
        director: String,
        image: String
    ) {
        self.name = name
        self.rate = rate
        self.director = director
        self.image = image
    }
}
