//
//  MovieCellCollectionViewCell.swift
//  PopularMovies
//
//  Created by Eric Internicola on 5/6/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieLabel: UILabel!

    var movie: Movie! {
        didSet {
            configureCell(movie)
        }
    }

}

// MARK: - Helpers

private extension MovieCell {

    func configureCell(movie: Movie) {
        movieLabel.text = movie.title
        movieImage.image = nil

        guard let moviePosterURL = MovieManager.sharedManager.buildImageUrl(movie.posterPath, width: 500) else {
            return
        }

        print("loading image: \(moviePosterURL)")

        dispatch_async(dispatch_get_global_queue(0, 0)) { 
            if let data = NSData(contentsOfURL: moviePosterURL) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.movieImage.image = UIImage(data: data)
                }
            } else {
                print("Failed to load contents of image: \(moviePosterURL.absoluteString)")
            }
        }
    }
}