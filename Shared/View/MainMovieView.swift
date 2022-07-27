//
//  DataFlowExample.swift
//  Shared
//
//  Created by Hung-Chun Tsai on 2022-07-16.
//

import SwiftUI

struct MainMovieView: View {
    @StateObject var vm = MainMovieViewModel(selectedMovie: moviesListData.first!)
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Main Movie View")
                    .font(.title)
                    .padding()
                    .background(.brown)
                    .cornerRadius(15)
                
                Text("Current selected movie")
                Text("\(vm.selectedMovie.name)")
                    .font(.title2)
                    .padding(5)
                Image(decorative: vm.selectedMovie.image)

                ForEach(moviesListData) { movie in
                    Button {
                        vm.setMovie(movie)
                    } label: {
                        Text("Select \(movie.name)")
                    }
                }

                Spacer()

                Button {
                    vm.prepareRouteToDetail()
                } label: {
                    Text("Go to Movie's Details")
                        .foregroundColor(.white)
                }
                .padding()
                .background(.blue)
                .cornerRadius(5)
                
                // Invisible tag for navigate to destination
                NavigationLink(
                    destination: vm.routeToDestination(),
                    isActive: Binding(
                        get: { vm.destinationRouter != nil },
                        set: { navigate in
                            if !navigate {
                                vm.resetRoute()
                            }
                        }
                    )
                ) { EmptyView() }
            }
        }
    }
}



// MARK: PREVIEW

struct MainMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MainMovieView()
    }
}
