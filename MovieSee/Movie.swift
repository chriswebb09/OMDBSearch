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
    var director: String
    var rated: String
    var runtime: String
    var plot: String
    var posterURL: String
    var poster: UIImage
    var genre: [String]
    var released: String
    var actors: [String]
    
    init(title:String, director: String, rated: String, runtime:String, plot: String, posterURL: String, poster: UIImage, genre:[String], released: String, actors: [String]) {
        self.title = title
        self.director = director
        self.rated = rated
        self.runtime = runtime
        self.plot = plot
        self.posterURL = posterURL
        self.poster = poster
        self.genre = genre
        self.released = released
        self.actors = actors
    }
    
    init() {
        self.init(title:"N/A", director: "N/A", rated:"N/A", runtime: "N/A", plot:"N/A", posterURL: "none", poster: UIImage(), genre: ["None"], released: "N/A", actors: ["None"])
    }
}


//["Poster": https://images-na.ssl-images-amazon.com/images/M/MV5BMWJhYWQ3ZTEtYTVkOS00ZmNlLWIxZjYtODZjNTlhMjMzNGM2XkEyXkFqcGdeQXVyNzg5OTk2OA@@._V1_SX300.jpg, "Country": USA, "Plot": N/A, "Language": English, "Year": 1983, "Title": Star Wars, "Metascore": N/A, "Director": N/A, "Rated": N/A, "Runtime": N/A, "Writer": N/A, "imdbVotes": 362, "Genre": Action, Adventure, Sci-Fi, "imdbID": tt0251413, "Released": 01 May 1983, "imdbRating": 7.8, "Awards": N/A, "Actors": Harrison Ford, Alec Guinness, Mark Hamill, James Earl Jones, "Type": game, "Response": True]
