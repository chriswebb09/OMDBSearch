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
    
    var queue = OperationQueue()
    
    
    func makeGETRequest(withURLTerms terms: String, handler: @escaping (JSONData?) -> Void) {
        
        guard let url = URL(string: Constants.Web.searchURL + terms) else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: config)
        
        session.dataTask(with: urlRequest) { data, response, error in
            let op1 = BlockOperation(block: {
                guard let data = data else { handler(nil); return }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONData else { handler(nil); return }
                OperationQueue.main.addOperation({
                    handler(json)
                })
            })
            op1.completionBlock = {
                print("dispatched json")
            }
            self.queue.addOperation(op1)
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
            
            let op2 = BlockOperation(block: {
                guard let data = data, error == nil else { return }
                OperationQueue.main.addOperation({
                    handler(UIImage(data: data)!)
                })
            })
            op2.completionBlock = {
                print("Op2 finished")
            }
            self.queue.addOperation(op2)
        }
    }
    
    func searchAPI(withURL url: String?, terms: String?,  handler: @escaping (SearchResults?) -> Void) {
        
        var returnedMovies = [Movie]()
        makeGETRequest(withURLTerms: url!, handler: { json in
            var movieData = json?["Search"] as! [[String: AnyObject]]
            var movieResult = SearchResults()
            
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
                    
                    DispatchQueue.main.async {
                        movieResult.searchTerm = terms!
                        movieResult.searchResults = returnedMovies
                        handler(movieResult)
                    }
                })
            }
        })
    }
}
