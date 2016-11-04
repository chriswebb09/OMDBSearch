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
    
 var store = MovieDataStore.sharedInstance
    
    func makeGETRequest(withURLTerms terms: String, handler: @escaping (JSONData?) -> Void) {
        
        guard let url = URL(string: Constants.Web.searchURL + terms) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                
                guard let data = data else { handler(nil); return }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONData else { handler(nil); return }
                
                handler(json)
            }
        })
        
        task.resume()
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    
    func downloadImage(url: URL, handler: @escaping (UIImage) -> Void) {
        print("Download Started")
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                handler(UIImage(data: data)!)
            }
        }
    }
    
    func searchOmdbForTerm(_ searchTerm: String, completion : @escaping (_ results: SearchResults?, _ error : NSError?, _ json: JSONData?) -> Void){
        
        guard let searchURL = omdbURLForSearchTerm(searchTerm) else {
            let APIError = NSError(domain: "OMDBSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
            completion(nil, APIError, nil)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        self.getDataFromUrl(url: URL(string:Constants.Web.searchURL + searchTerm)!, completion: { data, response, error in
        
            if let _ = error {
                let APIError = NSError(domain: "OMDBSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                OperationQueue.main.addOperation({
                    completion(nil, APIError, nil)
                })
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    let APIError = NSError(domain: "OMDBSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError, nil)
                    })
                    return
            }
            
            do {
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONData else { return }
                // guard let movieData = json else { return }
                guard let movieResults = json["Search"] as? [JSONData] else { return }
                
                for movie in movieResults {
                    
                    var newMovie = Movie()
                    
                    newMovie.posterURL = (movie["Poster"] as? String)!
                    
                    newMovie.title = (movie["Title"] as? String)!
                    
                    self.downloadImage(url: URL(string: newMovie.posterURL)!, handler: { image in
                        newMovie.poster = image
                        let APIError = NSError(domain: "OMDBSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                        self.store.movieArray.append(newMovie)
                        var result = SearchResults(searchTerm: searchTerm, searchResults: self.store.movieArray)
                        self.store.searchResults.append(result)
                        var results = [SearchResults]()
                        results.append(result)
                        completion(result, APIError, json)
                    })
                    
                
                }
            }  catch _ {
                completion(nil, nil, nil)
                return
            }
        })
    }
}

fileprivate func omdbURLForSearchTerm(_ searchTerm:String) -> URL? {
    
    guard let escapeSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
        return nil
    }
    guard let url = URL(string:Constants.Web.omdbURL) else {
        return nil
    }
    
    return url
}



