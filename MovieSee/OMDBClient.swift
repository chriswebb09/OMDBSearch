//
//  OMDBClient.swift
//  Movees
//
//  Created by Christopher Webb-Orenstein on 11/8/16.
//  Copyright © 2016 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias JSONData = [String : Any]

class OMDBClient {
    var queue = OperationQueue()
    static let sharedInstance = OMDBClient()
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var pageNumber = 1
    
    func getNextPage() {
        pageNumber += 1
    }
    
    func getJSONData(withURLTerms terms: String, handler: @escaping (JSONData?) -> Void) {
        let pageNumberURL = "&page=\(pageNumber)"
        guard let url = URL(string: Constants.Web.searchURL + terms + pageNumberURL) else { return }
        let urlRequest = URLRequest(url: url)
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
        let urlRequest = URLRequest(url:url)
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            completion(data, response, error)
        }).resume()
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
    
    func searchAPI(withSearchTerms terms: String?,  handler: @escaping (SearchResults?) -> Void) {
        queue.name = "data queue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        getJSONData(withURLTerms: terms!, handler: { json in
            let movieData = json?["Search"] as! [[String: AnyObject]]
            var movieResult = SearchResults()
            var returnMovies = [Movie]()
            movieData.forEach { movieRes in
                let title = movieRes["Title"] as? String
                let posterURL = movieRes["Poster"] as? String
                let year = movieRes["Year"] as? String
                self.downloadImage(url: URL(string: posterURL!)!, handler: { image in
                    let newMovie = Movie(title: title!, posterURL: posterURL!, year: year!, poster: image)
                    returnMovies.append(newMovie)
                    let setMovies = Set(returnMovies)
                    movieResult.searchResults = Array(setMovies)
                    movieResult.searchTerm = terms!
                    handler(movieResult)
                })
            }
        })
    }
}
