//
//  HomeViewController.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class HomeViewController: UICollectionViewController {
    
    let store = MovieDataStore.sharedInstance
    
    @IBOutlet var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonItem: UIBarButtonItem!
    
    
    var searchURL = ""
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    fileprivate let reuseIdentifier = "MovieCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 40.0, left: 30.0, bottom: 50.0, right: 30.0)
    fileprivate let itemsPerRow: CGFloat = 2
}

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.searchButton.addTarget(self, action: #selector(downloadFromAPI), for: .touchUpInside)
    }
    
    func downloadFromAPI() {
        self.store.api.pageNumber = 1
        self.searchURL.removeAll()
        let searchTerms = searchField.text?.components(separatedBy: " ")
        if (searchField.text?.characters.count)! > 0 {
            for term in searchTerms! {
                if searchURL.characters.count > 0 {
                    searchURL = "\(searchURL)+\(term)"
                } else {
                    searchURL = term
                }
            }
            self.store.fetchData(searchTerms: searchField.text!, completion: { result in
                print(result)
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            })
        }
    }
}

private extension HomeViewController {
    func movieForIndexPath(_ indexPath: IndexPath) -> Movie {
        return self.store.movieArray[(indexPath as NSIndexPath).row]
    }
}
// MARK: - UICollectionViewDataSource
extension HomeViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        //return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store.movieArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCell
        let movie = movieForIndexPath(indexPath)
        cell.configureCell(movie: movie)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:150)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail" {
            let destinationVC = segue.destination as! MovieDetailViewController
            let cell = sender as! MovieCell
            let indexPaths = self.collectionView?.indexPath(for: cell)
            let sentMovie = movieForIndexPath(indexPaths!)
            destinationVC.passedMovie = sentMovie
        }
    }
}


