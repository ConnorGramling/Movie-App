//
//  Title.swift
//  Movie App
//
//  Created by Connor on 10/17/26.
//

import Foundation

struct TMDBAPIObject: Decodable {
    var results: [Title] = []
}

struct Title: Decodable, Identifiable, Hashable {
    // ? marks unfilled properties as nil
    var id: Int?
    var title: String?  // for movies
    var name: String?   // for tv
    var overview: String?
    var posterPath: String?
    
    static var previewTitles = [
        Title(id: 1, title: "Monsters Inc", name: "Monsters Inc", overview: "A movie about Monsters Inc", posterPath: Constants.testTitleURL),
        Title(id: 2, title: "Pulp Fiction", name: "Pulp Fiction", overview: "A movie about Pulp Fiction", posterPath: Constants.testTitleURL2),
        Title(id: 3, title: "Movie movie", name: "Movie movie", overview: "A movie about Movies", posterPath: Constants.testTitleURL3)
    ]
}
