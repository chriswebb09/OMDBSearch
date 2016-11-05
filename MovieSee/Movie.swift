//
//  Movie.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct Movie {
    var title: String
    var posterURL: String
    var year: String
    var poster: UIImage?
    
    init(title: String, posterURL: String, year: String, poster: UIImage?) {
        self.title = title
        self.posterURL = posterURL
        self.year = year
        self.poster = poster
    }
    
    init() {
        self.init(title: "N/A", posterURL: "None", year: "Unknown", poster: nil)
    }
    
    init(title: String, posterURL:String, year:String) {
        self.init(title:title, posterURL: posterURL, year: year, poster:nil)
    }
}
