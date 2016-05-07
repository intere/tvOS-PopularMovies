//
//  Movie.swift
//  PopularMovies
//
//  Created by Eric Internicola on 5/6/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import Foundation

class Movie: NSObject {
    var title: String!
    var overview: String!
    var posterPath: String!

    init(movieDict: [String: AnyObject]) {
        title = movieDict["title"] as? String ?? ""
        overview = movieDict["overview"] as? String ?? ""
        posterPath = movieDict["poster_path"] as? String ?? ""
    }
}
