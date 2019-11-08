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
    
    func getVenue(lat: Double, long: Double, venue: String, completionHandler: @escaping (Result<[Venue], AppError>) -> () ) {
        let formattedVenue = venue.replacingOccurrences(of: " ", with: "")
        var venueURL: URL {
            guard let url = URL(string: "https://api.foursquare.com/v2/venues/search?ll=\(lat),\(long)&client_id=\(Secret.clientID)&client_secret=\(Secret.clientSecret)&v=20191104&query=\(formattedVenue)&limit=3") else {fatalError("Error: Invalid URL")}
            return url
        }
        
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
    
    
    private init() {}
    
}
