//
//  SearchResults.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

struct SearchResults {
    var searchTerm : String
    var searchResults : [Movie]
    
    init() {
        self.searchTerm = ""
        self.searchResults = [Movie]()
    }
}
