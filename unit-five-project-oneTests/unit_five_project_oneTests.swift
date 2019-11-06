//
//  unit_five_project_oneTests.swift
//  unit-five-project-oneTests
//
//  Created by Levi Davis on 11/6/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import XCTest
@testable import unit_five_project_one

class unit_five_project_oneTests: XCTestCase {

    func testVenueDataFromJSON() {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "venueJSON", ofType: "json") else {XCTFail("Could not fund JSON file"); return}
        let urlFromFile = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: urlFromFile)
            guard let venueData = try VenueWrapper.getVenues(from: data) else {XCTFail(); return}
            XCTAssert(venueData.count > 0)
        } catch {
            XCTFail()
            print(error)
        }
    }
    
    func testPhotoDataFromJSON() {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "photoJSON", ofType: "json") else {XCTFail(); return}
        
        let urlFromFile = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: urlFromFile)
            guard let photoData = try PhotoWrapper.getImages(from: data) else {XCTFail(); return}
            XCTAssert(photoData.count > 0)
        } catch {
            XCTFail()
            print(error)
        }
    }

}
