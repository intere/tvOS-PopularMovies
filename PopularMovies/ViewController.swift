//
//  ViewController.swift
//  PopularMovies
//
//  Created by Eric Internicola on 5/6/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    let defaultSize = CGSizeMake(280, 422)
    let focusedSize = CGSizeMake(308, 464)

    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        loadMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - UICollectionViewDelegate Methods

extension ViewController : UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension ViewController : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCell", forIndexPath: indexPath)

        if let cell = cell as? MovieCell {
            cell.movie = movies[indexPath.row]

            if cell.gestureRecognizers == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
                tap.allowedPressTypes = [NSNumber(integer:UIPressType.Select.rawValue)]
                cell.addGestureRecognizer(tap)
            }
        }

        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSizeMake(343, 535)
    }

}

// MARK: - Actions

extension ViewController {

    func tapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? MovieCell {
            print("You selected the movie: \(cell.movie.title)")
        }
    }

}

// MARK: - Helper Methods

private extension ViewController {

    func loadMovies() {
        MovieManager.sharedManager.downloadData { (movies, errorMessage) in
            if let errorMessage = errorMessage {
                print("Failed to load movies: \(errorMessage)")
                return
            }
            guard let movies = movies else {
                print("We didn't load any movies")
                return
            }
            self.movies = movies

            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }

}