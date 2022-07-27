//
//  MovieDetailsViewModel.swift
//  NavigationRouterPractice (iOS)
//
//  Created by Hung-Chun Tsai on 2022-07-26.
//

import Foundation

class MovieDetailsViewModel: ObservableObject {
    @Published var selectedMovie: Movie
    private var accountList: [Movie] = []
    
    init(selectedAccount: Movie) {
        self.selectedMovie = selectedAccount
        self.accountList = moviesListData
    }

    func setMovie(_ movie: Movie) {
        selectedMovie = movie
    }
}
