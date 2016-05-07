//
//  MovieManager.swift
//  PopularMovies
//
//  Created by Eric Internicola on 5/6/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import UIKit

typealias MoviesLoadCallback = (movies: [Movie]?, errorMessage: String?) -> Void

class MovieManager: NSObject {
    static let sharedManager = MovieManager()

    let apiKey = "b2acc0bb6bd8d9ec9aa503240ccdd136"

    func downloadData(callback: MoviesLoadCallback) {
        guard let url = getUrl("/3/movie/popular/") else {
            callback(movies: nil, errorMessage: "Couldn't create the URL")
            return
        }

        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            if let error = error {
                callback(movies: nil, errorMessage: "ERROR with request: \(error.localizedDescription)")
                return
            }
            guard let response = response as? NSHTTPURLResponse else {
                callback(movies: nil, errorMessage: "ERROR: The response is not an HTTP URL Response object")
                return
            }
            guard 200..<300 ~= response.statusCode else {
                callback(movies: nil, errorMessage: "Received an HTTP \(response.statusCode) from GET from URL: \(url.absoluteString)")
                return
            }
            guard let data = data else {
                callback(movies: nil, errorMessage: "ERROR: No data received")
                return
            }

            guard let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
                callback(movies: nil, errorMessage: "ERROR: Couldn't deserialize JSON")
                return
            }

            guard let results = dict?["results"] as? [[String: AnyObject]] else {
                callback(movies: nil, errorMessage: "We don't have results")
                return
            }

            var movies = [Movie]()

            for movieJson in results {
                movies.append(Movie(movieDict: movieJson))
            }

            callback(movies: movies, errorMessage: nil)

        }.resume()
    }

    func getUrl(path: String) -> NSURL? {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "api.themoviedb.org"
        components.path = path

        components.queryItems = [
            NSURLQueryItem(name: "api_key", value: apiKey)
        ]

        return components.URL
    }

    func buildImageUrl(imageName: String, width: Int) -> NSURL? {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "image.tmdb.org"
        components.path = "/t/p/w\(width)\(imageName)"

        return components.URL
    }
}
