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
    
    func searchOmdbForTerm(_ searchTerm: String, completion : @escaping (_ results: SearchResults?, _ error : NSError?) -> Void){
        
        guard let searchURL = omdbURLForSearchTerm(searchTerm) else {
            let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
            completion(nil, APIError)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchRequest, completionHandler: { (data, response, error) in
            
            if let _ = error {
                let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                OperationQueue.main.addOperation({
                    completion(nil, APIError)
                })
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
            }
            
            do {
                
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                    let stat = resultsDictionary["stat"] as? String else {
                        
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                        return
                }
                
                
                switch (stat) {
                case "ok":
                    print("Results processed OK")
                case "fail":
                    if let message = resultsDictionary["message"] {
                        
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:message])
                        
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                    }
                    
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: nil)
                    
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    
                    return
                default:
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
            
            
//                guard let photosContainer = resultsDictionary["photos"] as? [String: AnyObject], let photosReceived = photosContainer["photo"] as? [[String: AnyObject]] else {
//                    
//                    let APIError = NSError(domain: "OMDB", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
//                    OperationQueue.main.addOperation({
//                        completion(nil, APIError)
//                    })
//                    return
//                }
                
//                var flickrPhotos = [FlickrPhoto]()
                
//                for photoObject in photosReceived {
//                    guard let photoID = photoObject["id"] as? String,
//                        let farm = photoObject["farm"] as? Int ,
//                        let server = photoObject["server"] as? String ,
//                        let secret = photoObject["secret"] as? String else {
//                            break
//                    }
//                  //  let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
//                    l
//                    guard let url = flickrPhoto.flickrImageURL(),
//                        let imageData = try? Data(contentsOf: url as URL) else {
//                            break
//                    }
//                    
//                    if let image = UIImage(data: imageData) {
//                        flickrPhoto.thumbnail = image
//                        flickrPhotos.append(flickrPhoto)
//                    }
//                }
                
//                OperationQueue.main.addOperation({
//                    completion(omdbURLForSearchTerm(searchTerm: searchTerm, searchResults: Movie), nil)
//                })
                
            } catch _ {
                completion(nil, nil)
                return
            }
            
            
        }) .resume()
    }
    
    fileprivate func omdbURLForSearchTerm(_ searchTerm:String) -> URL? {
        
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
       // let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        
        guard let url = URL(string:Constants.Web.omdbURL) else {
            return nil
        }
        
        return url
    }

    
}
