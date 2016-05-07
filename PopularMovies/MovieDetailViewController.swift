//
//  MovieDetailViewController.swift
//  PopularMovies
//
//  Created by Eric Internicola on 5/7/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieOverviewLabel: UILabel!

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView(movie)
    }

}


private extension MovieDetailViewController {

    func configureView(movie: Movie) {

        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview

        guard let moviePosterURL = MovieManager.sharedManager.buildImageUrl(movie.posterPath, width: 500) else {
            return
        }

        dispatch_async(dispatch_get_global_queue(0, 0)) {
            if let data = NSData(contentsOfURL: moviePosterURL) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.movieImageView.image = UIImage(data: data)
                }
            } else {
                print("Failed to load contents of image: \(moviePosterURL.absoluteString)")
            }
        }
    }

}