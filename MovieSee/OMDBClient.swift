//
//  OMDBClient.swift
//  MovieSee
//
//  Created by Christopher Webb-Orenstein on 11/4/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias JSONData = [String : Any]

class OMDBClient {
    
    static let sharedInstance = OMDBClient()
    var store = MovieDataStore.sharedInstance
    
    let config = URLSessionConfiguration.default
    
    //    func makeGETRequest(withURLTerms terms: String, handler: @escaping (Movie?) -> Void) {
    //
    //        guard let url = URL(string: Constants.Web.searchURL + terms) else {
    //            print("Error: cannot create URL")
    //            return
    //        }
    //
    //        let urlRequest = URLRequest(url: url)
    //
    //        let session = URLSession(configuration: config)
    //
    //        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
    //            guard let data = data else { handler(nil); return }
    //            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONData else { handler(nil); return }
    //
    //            var newMovie = Movie()
    //
    //
    //
    //
    //
    ////            var newMovie = Movie()
    ////            guard let title = json["Poster"] else { return }
    ////            guard let posterUrl = json["Poster"] else { return }
    ////            newMovie.title = (title as? String)!
    ////            newMovie.posterURL = (posterUrl as? String)!
    ////            self.store.movieArray.append(newMovie)
    ////            DispatchQueue.main.async {
    ////                handler(newMovie)
    //            }
    //        })
    //        task.resume()
    //    }
    //
    
    
    
    
    func makeGETRequest(withURLTerms terms: String, handler: @escaping (JSONData?) -> Void) {
        
        guard let url = URL(string: Constants.Web.searchURL + terms) else { return }
        
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { handler(nil); return }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONData else { handler(nil); return }
                handler(json)
            }
            }.resume()
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    
    
    func downloadImage(url: URL, handler: @escaping (UIImage) -> Void) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            
            guard let data = data, error == nil else { return }
            
            // print("Download Finished")
            
            DispatchQueue.main.async() { () -> Void in
                handler(UIImage(data: data)!)
            }
        }
    }
    
    func searchAPI(withURL url: String?, terms: String?,  handler: @escaping (SearchResults?) -> Void) {
        print("URL \(url!)\n\n\n\n")
        var returnedMovies = [Movie]()
        makeGETRequest(withURLTerms: url!, handler: { json in
            //print(json)
            
            
            var movieData = json?["Search"] as! [[String: AnyObject]]
            var movieResult = SearchResults()
            
            //            var newMovie = Movie()
            movieData.forEach { movieRes in
                let title = movieRes["Title"] as? String
                let posterURL = movieRes["Poster"] as? String
                let year = movieRes["Year"] as? String
                
                self.downloadImage(url: URL(string: posterURL!)!, handler: { image in
                    dump(image)
                    
                    returnedMovies.append(Movie(title: title!, posterURL: posterURL!, year: year!, poster: image))
                    DispatchQueue.main.async {
                        movieResult.searchResults.append(Movie(title: title!, posterURL: posterURL!, year: year!, poster: image))
                    }
                    movieResult.searchTerm = terms!
                    movieResult.searchResults = returnedMovies
                    handler(movieResult)
                })
                
                //                DispatchQueue.main.async {
                //                    handler(movieResult)
                //                }
                
                //movieResult.searchResults = movies
                
            }
            print(returnedMovies.count)
            handler(movieResult)
        })
    }
}
//                print(movieRes)
//                let newMovie = movieRes as! Movie
//               // let movie = movieRes as! Movie
//               print("DATA \(newMovie)\n")

//                guard let title = data["Title"] as? String else { return }
//                //movies.append(Movie())


//var searchResult = SearchResults(searchTerm: term, searchResults: <#T##[Movie]#>)
//var searchResult = SearchResults(searchTerm:terms, )
//        })
//        handler(nil)
//    }
//        makeGETRequest(withURLTerms: terms!, handler: { movie in
//            downloadImage(url: URL(string: (movie?.posterURL)!)!, handler: { image in
//                let results = movie?.poster = image
//            })
//        })




