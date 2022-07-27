//
//  MainMovieViewModel.swift
//  NavigationRouterPractice (iOS)
//
//  Created by Hung-Chun Tsai on 2022-07-26.
//

import SwiftUI
import Combine

class MainMovieViewModel: ObservableObject {
    @Published var selectedMovie: Movie
    @Published var destinationRouter: MyRouter? = nil

    private var moviesList: [Movie] = []
    var cancellable: Set<AnyCancellable> = []

    // Source of truth for the child view model, the parent's vm hold the reference
    var secondViewModel: MovieDetailsViewModel?
    
    init(selectedMovie: Movie) {
        self.selectedMovie = selectedMovie
        self.moviesList = moviesListData
        self.secondViewModel = MovieDetailsViewModel(selectedAccount: selectedMovie)
    }

    func prepareRouteToDetail() {
        // Before initiating the route, generate the needed data for the viewModel
        secondViewModel = MovieDetailsViewModel(selectedAccount: selectedMovie)

        // Suscribe to the child vm's selectedMovie. Whenever the value is change in child's view. We assign back to current vm.
        secondViewModel?.$selectedMovie
            .sink(receiveValue: { movie in
                self.selectedMovie = movie
            })
            .store(in: &cancellable)

        if let secondViewModel = secondViewModel {
            // initate the route
            destinationRouter = .movieDetail(secondViewModel)
        }
    }

    func setMovie(_ movie: Movie) {
        selectedMovie = movie
    }

    // Creating the destination view base on corresponding scenario.
    @ViewBuilder
    func routeToDestination() -> some View {
        if let destinationRouter = destinationRouter {
            switch destinationRouter {
            case .movieDetail(let secondViewModel):
                MovieDetailsView(vm: secondViewModel)
            }
        }
    }

    func resetRoute() {
        destinationRouter = nil
        secondViewModel = nil
    }
}
