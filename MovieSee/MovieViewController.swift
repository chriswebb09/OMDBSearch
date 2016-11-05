//
//  MovieViewController.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class MovieViewController: UICollectionViewController {
    
    let movieStore = MovieDataStore.sharedInstance
    
    
    @IBOutlet weak var searchButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIButton!
    
    fileprivate var movieArray = [Movie]()
    
    fileprivate let reuseIdentifier = "MovieCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var searches = [SearchResults]()
    fileprivate let omdbClient = OMDBClient()
    fileprivate let itemsPerRow: CGFloat = 2
    
    fileprivate var imageArray = [UIImage]()
    
    var indexOfSelected: Int?
    
    
    var posterImage: UIImage!
    
    @IBOutlet weak var searchField: UITextField!
    
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MovieViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private
private extension MovieViewController {
    func movieForIndexPath(_ indexPath: IndexPath) -> Movie {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UICollectionViewDataSource
extension MovieViewController {
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
        //2
        //let movie = movieForIndexPath(indexPath)
        
        cell.backgroundColor = UIColor.white
        //cell.imageView.image = imageArray[0]
        //3
        //cell.imageView.image = movie.poster
        //print(self.imageArray)
        //        if imageArray.count > 0 {
        //            cell.imageView.image = posterImage
        //        }
        let reviseIndex = indexPath.row
        print(indexPath.row)
        cell.imageView.image = movieArray[reviseIndex].poster
        cell.titleLabel.text = movieArray[indexPath.row].title
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:150)
    }
}


extension MovieViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetail" {
            let detailsVC = segue.destination as! MovieDetailViewController
            if let cell = sender as? UICollectionViewCell, let indexPath = collectionView!.indexPath(for: cell) {
                // use indexPath
                print(movieArray[indexPath.row].title)
                detailsVC.passedMovie = self.movieStore.movieArray[indexPath.row]
                print(detailsVC.passedMovie)
            }
        }
    }
}
