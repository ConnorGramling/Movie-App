//
//  Title.swift
//  Movie App
//
//  Created by Connor on 10/17/26.
//

import SwiftData

struct TMDBAPIObject: Decodable {
    var results: [Title] = []
}

@Model  // marks the class as storable
class Title: Decodable, Identifiable, Hashable {
    // ? marks unfilled properties as nil - missing data
    @Attribute(.unique) var id: Int? // makes sure each id saved is unique
    var title: String?  // for movies
    var name: String?   // for tv
    var overview: String?
    var posterPath: String?
    
    init(id: Int? = nil, title: String? = nil, name: String? = nil, overview: String? = nil, posterPath: String? = nil) {
         self.id = id
        self.title = title
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
    }
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case name
        case overview
        case posterPath
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
    
    // for testing
    static var previewTitles = [
        Title(id: 1, title: "Monsters Inc", name: "Monsters Inc", overview: "A movie about Monsters Inc", posterPath: Constants.testTitleURL),
        Title(id: 2, title: "Pulp Fiction", name: "Pulp Fiction", overview: "A movie about Pulp Fiction", posterPath: Constants.testTitleURL2),
        Title(id: 3, title: "Movie movie", name: "Movie movie", overview: "A movie about Movies", posterPath: Constants.testTitleURL3)
    ]
}
