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
    
    let shared = OMDBClient.sharedInstance
    
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
        shared.searchAPI(withURL: "me", terms: "me",  handler: { result in
            self.store.searchResults.append(result!)
            
            print(self.store.searchResults)
            self.store.searchResults.forEach { mov in

                self.store.movieArray = mov.searchResults
                self.collectionView?.reloadData()
            }
        })

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
            
//            omdbClient.searchAPI(withURL: searchURL, terms: searchTerms?[0], handler: { jsonDict in
//                print(jsonDict)
//            })
//            omdbClient.makeGETRequest(withURLTerms:searchURL, handler: { json in
//                print(self.store.movieArray)
//                self.collectionView?.reloadData()
//            })
        }
    }
}



private extension HomeViewController {
    func movieForIndexPath(_ indexPath: IndexPath) -> Movie {
        return self.store.movieArray[(indexPath as NSIndexPath).row]
        //return self.store.searchResultss[(indexPath as NSIndexPath).row]
        //return (searches.last?.searchResults[(indexPath as NSIndexPath).row])!
        //return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        //return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("------\n\n\n\n\n")
        print(self.store.movieArray.count)
        
        return self.store.movieArray.count
        //return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCell
        //cell.backgroundColor = UIColor.white
        
        cell.layer.cornerRadius = 2
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize(width: 6, height: 10)
        cell.layer.shadowRadius = 6
        
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        
        cell.layer.shouldRasterize = true
        //let movie = self.searches[self.searches.count - 1].searchResults[indexPath.row]
        let movie = movieForIndexPath(indexPath)
        cell.imageView.image = movie.poster!
        cell.titleLabel.text = movie.title
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:150)
    }
}
