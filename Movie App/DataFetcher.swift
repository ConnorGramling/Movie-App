//
//  DataFetcher.swift
//  Movie App
//
//  Created by Connor on 10/20/26.
//

import Foundation

struct DataFetcher {
    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey  // ? optional stops definition if nil after shared
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey

    //https://api.themoviedb.org/3/trending/movie/day?api_key=MY_API_KEY
    //https://api.themoviedb.org/3/movie/top_rated?api_key=MY_API_KEY
    //https://api.themoviedb.org/3/movie/upcoming?api_key=MY_API_KEY
    //https://api.themoviedb.org/3/search/movie?api_key=MY_API_KEY&query=Avengers

    func fetchTitles(for media: String, by type: String, with title:String? = nil) async throws -> [Title] {  //use async throws to call on seperate thread incase failure and to prevent app lag
        let fetchTitlesURL = try buildURL(media: media, type: type, searchPhrase: title)

        guard let fetchTitlesURL = fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }

        //print(fetchTitlesURL)
        var titles = try await fetchAndDecode(
            url: fetchTitlesURL,
            type: TMDBAPIObject.self
        ).results

        Constants.addPosterPath(to: &titles)
        return titles
    }

    //https://www.googleapis.com/youtube/v3/search?q=Breaking%20Bad%20trailer&key=APIKEY
    func fetchVideoId(for title: String) async throws -> String {
        guard let baseSearchURL = youtubeSearchURL else {
            throw NetworkError.missingConfig
        }

        guard let searchAPIKey = youtubeAPIKey else {
            throw NetworkError.missingConfig
        }

        let trailerSearch =
            title + YoutubeURLSrtings.space.rawValue
            + YoutubeURLSrtings.trailer.rawValue  // enum instead of hardcoding

        guard
            let fetchVideoURL = URL(string: baseSearchURL)?.appending(
                queryItems: [
                    URLQueryItem(
                        name: YoutubeURLSrtings.queryShorten.rawValue,
                        value: trailerSearch
                    ),
                    URLQueryItem(
                        name: YoutubeURLSrtings.key.rawValue,
                        value: searchAPIKey
                    ),
                ])
        else {
            throw NetworkError.urlBuildFailed
        }

        //print(fetchVideoURL)

        return try await fetchAndDecode(
            url: fetchVideoURL,
            type: YoutubeSearchResponse.self
        ).items?.first?.id?.videoId ?? ""
    }

    // generic helper function for decoding urls
    func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T
    {
        let (data, urlResponse) = try await URLSession.shared.data(from: url)  //returns 2 types - data raw json data and request meta data, try - external network, await - async thread

        guard let response = urlResponse as? HTTPURLResponse,
            response.statusCode == 200
        else {  //check if valid url and success(200)
            throw NetworkError.badURLResponse(
                underlyingError: NSError(
                    domain: "DataFetcher",
                    code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,  //if no code found default -1
                    userInfo: [
                        NSLocalizedDescriptionKey: "Invalid HTTP Response"
                    ]
                )
            )
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase  //convert snake_case to camelCase
        return try decoder.decode(type, from: data)
    }

    // helper function change depending on what is needed from MovieAPI (ex: trending, top rated,...)
    private func buildURL(media: String, type: String, searchPhrase:String? = nil) throws -> URL? {
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfig
        }
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }

        var path: String

        switch type {
        case "trending":
            path = "3/\(type)/\(media)/day"
        case "top_rated", "upcoming":
            path = "3/\(media)/\(type)"
        case "search":
            path = "3/\(type)/\(media)"
        default:
            throw NetworkError.urlBuildFailed
        }
        
        var urlQuerryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        if let searchPhrase {   // if search phrase present add to url
            urlQuerryItems.append(URLQueryItem(name: "query", value: searchPhrase))
        }

        guard let url = URL(string: baseURL)?
                .appending(path: path)
                .appending(queryItems: urlQuerryItems)
        else {
            throw NetworkError.urlBuildFailed
        }

        return url
    }
}
