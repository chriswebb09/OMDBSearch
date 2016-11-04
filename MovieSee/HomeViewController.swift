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
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonItem: UIBarButtonItem!
    
    var searchURL = ""
    
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
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.searchButton.addTarget(self, action: #selector(downloadFromAPI), for: .touchUpInside)
        activityIndicator.hidesWhenStopped = true
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
        
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        OMDBClient().searchOmdbForTerm(textField.text!) {
            results, error, json in
            self.activityIndicator.removeFromSuperview()
            if let error = error {
                print("Error searching : \(error)")
                return
            }
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
            }
        }
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    func downloadFromAPI() {
        let client = OMDBClient()
        let searchTerms = searchField.text?.components(separatedBy: " ")
        if (searchField.text?.characters.count)! > 0 {
            for term in searchTerms! {
                if searchURL.characters.count > 0 {
                    searchURL = "\(searchURL)+\(term)"
                } else {
                    searchURL = term
                }
            }
            client.searchOmdbForTerm(searchURL, completion: { result, error, json in
                self.searches.append(result!)
                self.collectionView?.reloadData()
            })
        }
    }
}


private extension HomeViewController {
    func movieForIndexPath(_ indexPath: IndexPath) -> Movie {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCell
        cell.backgroundColor = UIColor.white
        self.searches[self.searches.count - 1].searchResults[indexPath.row]
        let movie = self.searches[self.searches.count - 1].searchResults[indexPath.row]
        if self.searches.count > 0 {
            if movie.poster != nil {
                cell.imageView.image = movie.poster
            }
            cell.titleLabel.text = movie.title
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:150)
    }
}
