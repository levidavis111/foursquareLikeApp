//
//  PhotoAPIClient.swift
//  unit-five-project-one
//
//  Created by Levi Davis on 11/6/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
struct PhotoAPIClient {
    
    static let manager = PhotoAPIClient()
    
    func getPhotos(id: String, completionHandler: @escaping (Result<[Item], AppError>) -> () ) {
        var imagesURL: URL {
               guard let url = URL(string: "https://api.foursquare.com/v2/venues/\(id)/photos?client_id=\(Secret.clientID)&client_secret=\(Secret.clientSecret)&v=20191104&limit=3") else {fatalError("Error: Invalid URL")}
               return url
           }
        
        NetworkManager.manager.performDataTask(withUrl: imagesURL, httpMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
            case .success(let data):
                do {
                    let images = try PhotoWrapper.getImages(from: data)
                    guard let imagesUnwrapped = images else {completionHandler(.failure(.invalidJSONResponse));return
                    }
                    completionHandler(.success(imagesUnwrapped))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
        
    }
   
    
    private init() {}
    
}
