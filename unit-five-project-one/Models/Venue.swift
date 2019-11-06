//
//  Venue.swift
//  unit-five-project-one
//
//  Created by Levi Davis on 11/6/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation

struct VenueWrapper: Codable {
    let response: Venues
    
    static func getVenues(from jsonData: Data) throws -> [Venue]? {
       
            let response = try JSONDecoder().decode(VenueWrapper.self, from: jsonData)
            return response.response.Venues

    }
}

struct Venues: Codable {
    let Venues: [Venue]
}

struct Venue: Codable {
    let id: String
    let name: String
    let crossStreet: String
    let lat: Double
    let lng: Double
    let distance: Int
    let formattedAddress: [String]
    
}
