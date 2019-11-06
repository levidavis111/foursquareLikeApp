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
    
    func getCategory(completionHandler: @escaping (Result<[Item], AppError>) -> () ) {
        
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
    var imagesURL: URL {
        guard let url = URL(string: "https://api.foursquare.com/v2/venues/412d2800f964a520df0c1fe3/photos?client_id=\(Secret.clientID)&client_secret=\(Secret.clientSecret)&v=20191104") else {fatalError("Error: Invalid URL")}
        return url
    }
    
    private init() {}
    
}
