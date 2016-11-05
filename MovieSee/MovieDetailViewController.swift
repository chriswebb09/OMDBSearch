//
//  MovieDetailViewController.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var passedMovie: Movie = Movie()
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedMovie)
        moviePoster.image = passedMovie.poster
        movieTitleLabel.text = passedMovie.title
    }
}
