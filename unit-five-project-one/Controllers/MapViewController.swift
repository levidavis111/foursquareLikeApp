//
//  MapViewController.swift
//  unit-five-project-one
//
//  Created by Levi Davis on 11/6/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        return mapView
    }()
    
    lazy var venueSearchBar: UISearchBar = {
        let venueSearchBar = UISearchBar()
        venueSearchBar.placeholder = "Enter Venue"
        return venueSearchBar
    }()

    lazy var locationSearchBar: UISearchBar = {
        let locationSearchBar = UISearchBar()
        locationSearchBar.placeholder = "Enter Location"
        return locationSearchBar

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        constrainSubviews()
        
    }
    
       
}

extension MapViewController {
    private func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(venueSearchBar)
        view.addSubview(locationSearchBar)
    }
    
    private func constrainSubviews() {
        constrainMapView()
        constrainVenueSearchBar()
        constrainLocationSearchBar()
    }
    
    private func constrainMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        [mapView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor),
         mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
        
    }
    
    private func constrainVenueSearchBar() {
        venueSearchBar.translatesAutoresizingMaskIntoConstraints = false
        [venueSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         venueSearchBar.heightAnchor.constraint(equalToConstant: 50),
         venueSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         venueSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
    
    private func constrainLocationSearchBar() {
        locationSearchBar.translatesAutoresizingMaskIntoConstraints = false
        [locationSearchBar.topAnchor.constraint(equalTo: venueSearchBar.bottomAnchor),
         locationSearchBar.heightAnchor.constraint(equalToConstant: 50),
         locationSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         locationSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
    
    
}

