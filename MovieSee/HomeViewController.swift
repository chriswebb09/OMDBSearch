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
    
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var searchURL = ""
    var imageURL: URL!
    
    fileprivate let reuseIdentifier = "MovieCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var searches = [SearchResults]()
    fileprivate let omdbClient = OMDBClient()
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate var imageArray = [UIImage]()
    
}

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.searchButton.addTarget(self, action: #selector(downloadImageForCell), for: .touchUpInside)
    }
}

extension HomeViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let searchTerms = searchField.text?.components(separatedBy: " ")
        
        if (searchField.text?.characters.count)! > 0 {
            for term in searchTerms! {
                if searchURL.characters.count > 0 {
                    searchURL = "\(searchURL)+\(term)"
                } else {
                    searchURL = term
                }
            }
            print(searchURL)
        }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        OMDBClient().searchOmdbForTerm(textField.text!) {
            results, error in
            activityIndicator.removeFromSuperview()
            if let error = error {
                print("Error searching : \(error)")
                return
            }
            
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                self.collectionView?.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    func downloadImageForCell() {
        let client = OMDBClient()
        client.makeGETRequest(withURLTerms: searchURL, handler: { json in
            guard let movieData = json else { return }
            guard let movieResults = movieData["Search"] as? [JSONData] else { return }
            for movieResult in movieResults {
                var newMovie = Movie()
                
                newMovie.posterURL = movieResult["Poster"] as! String
                
                newMovie.title = movieResult["Title"] as! String
                
                self.imageURL = URL(string: newMovie.posterURL)!
                self.store.movieArray.removeAll()
                client.downloadImage(url: self.imageURL, handler: { image in
                    newMovie.poster = image
                    //self.posterImage = image
                    //self.store.movieArray.append(newMovie)
                    self.store.movieArray.append(newMovie)
                    //self.movieStore.movieArray.append(newMovie)
                    self.imageArray.append(image)
                    self.collectionView?.reloadData()
                })
            }
        })
    }
}


private extension HomeViewController {
    func movieForIndexPath(_ indexPath: IndexPath) -> Movie {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController {
    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        //return searches.count
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        print(imageArray.count)
        //return movieArray.count
        return searches[section].searchResults.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! MovieCell
        cell.backgroundColor = UIColor.white
        print(indexPath.row)
        cell.imageView.image = self.store.movieArray[indexPath.row].poster
        cell.titleLabel.text = self.store.movieArray[indexPath.row].title
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:150)
    }
}
