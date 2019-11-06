//
//  VenueAPIClient.swift
//  unit-five-project-one
//
//  Created by Levi Davis on 11/6/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation

struct VenueAPIClient {
    
    static let manager = VenueAPIClient()
    
    func getVenue(completionHandler: @escaping (Result<[Venue], AppError>) -> () ) {
        
        NetworkManager.manager.performDataTask(withUrl: venueURL, httpMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
            case .success(let data):
                do {
                    let venues = try VenueWrapper.getVenues(from: data)
                    guard let venuesUnwrapped = venues else {completionHandler(.failure(.invalidJSONResponse));return
                    }
                    completionHandler(.success(venuesUnwrapped))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
        
    }
    var venueURL: URL {
        guard let url = URL(string: "https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=\(Secret.clientID)&client_secret=\(Secret.clientSecret)&v=20191104&query=centralpark&limit=1000") else {fatalError("Error: Invalid URL")}
        return url
    }
    
    private init() {}
    
}
