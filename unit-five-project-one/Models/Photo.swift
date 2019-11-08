//
//  Photo.swift
//  unit-five-project-one
//
//  Created by Levi Davis on 11/6/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct PhotoWrapper: Codable {
    let response: ResponseWrapper
    
    static func getImages(from jsonData: Data) throws -> [Item]? {
        let response = try JSONDecoder().decode(PhotoWrapper.self, from: jsonData)
        
        return response.response.photos.items
    }
}

struct ResponseWrapper: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: String
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
}
