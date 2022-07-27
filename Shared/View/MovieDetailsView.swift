//
//  MovieDetailsView.swift
//  NavigationRouterPractice (iOS)
//
//  Created by Hung-Chun Tsai on 2022-07-26.
//

import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var vm: MovieDetailsViewModel

    var body: some View {
        VStack {
            Text("Movie Detail's View")
                .font(.title)
                .background(.cyan)
                .cornerRadius(15)
            Text("Selected Movie:")
            Text("\(vm.selectedMovie.name)")
            Image(decorative: vm.selectedMovie.image)
                .font(.title2)
            Text("Rate: \(vm.selectedMovie.rate, specifier: "%.1f")")
            Text("Director: \(vm.selectedMovie.director)")

            Spacer()
            ForEach(moviesListData) { movie in
                Button {
                    vm.setMovie(movie)
                } label: {
                    Text("Select \(movie.name)")
                }
            }
            Spacer()
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(vm: MovieDetailsViewModel(selectedAccount: moviesListData.first!))
    }
}
