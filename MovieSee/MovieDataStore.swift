//
//  DataStore.swift
//  Movees
//
//  Created by Christopher Webb-Orenstein on 11/8/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

class MovieDataStore {
    
    static let sharedInstance = MovieDataStore()
    
    var movieArray = [Movie]()
    var searchResults = [SearchResults]()
    let api = OMDBClient.sharedInstance
    
    func fetchData(searchTerms terms:String, completion: @escaping (SearchResults)-> Void) {
        api.searchAPI(withSearchTerms: terms, handler: { result in
            self.searchResults = [result!]
            self.movieArray = (result?.searchResults)!
            completion(result!)
        })
    }
    
}
