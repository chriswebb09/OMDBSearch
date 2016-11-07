//
//  AsyncOperations.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/5/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class DownloadImages: Operation {
    var movies = [Movie]()
    
    init(movies: [Movie]) {
        self.movies = movies
    }
}

