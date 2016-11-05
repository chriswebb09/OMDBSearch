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
    fileprivate let sectionInsets = UIEdgeInsets(top: 40.0, left: 30.0, bottom: 50.0, right: 30.0)
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
    //searchField
    
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
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    func downloadFromAPI() {
        self.searches.removeAll()
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
            searchField.addSubview(activityIndicator)
            activityIndicator.frame = searchField.bounds
            activityIndicator.startAnimating()

            self.searches.removeAll()
            client.searchOmdbForTerm(searchURL, completion: { result, error, json, page in
//                if Int(page!)! > 10 {
//                    client.searchOmdbForTerm(self.searchURL + "&page=2", completion: { result, error, json, page in
//                        print(page!)
//                        self.searches.append(result!)
//                        self.collectionView?.reloadData()
//                    })
//                    
//                }
                
                print(page!)
                self.searches.append(result!)
                self.activityIndicator.stopAnimating()
                self.collectionView?.reloadData()
            })
        }
        collectionView?.reloadData()
    }
}


private extension HomeViewController {
    func movieForIndexPath(_ indexPath: IndexPath) -> Movie {
        return (searches.last?.searchResults[(indexPath as NSIndexPath).row])!
        //return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
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
        
        //let movie = self.searches[self.searches.count - 1].searchResults[indexPath.row]
        let movie = movieForIndexPath(indexPath)
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
