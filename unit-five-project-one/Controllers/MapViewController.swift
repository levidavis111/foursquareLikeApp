//
//  MapViewController.swift
//  unit-five-project-one
//
//  Created by Levi Davis on 11/6/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var lat = 40.742054
    private var long = -73.769417
    private var venue: String = "central park"
    
    private let cellSpacing: CGFloat = 5.0
    
    let initialLocation = CLLocation(latitude: 40.742054, longitude: -73.769417)
    let searchRadius: Double = 2000
    
    private var venues = [Venue]() {
        didSet {
            //            mapView.addAnnotations(venues.map{$0.location})
            venues.forEach{(location) in
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                annotation.coordinate = location.location.coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    private var photos = [Item]()
    
    var venueSearchString: String? = nil {
        didSet {
            mapView.addAnnotations(venues.map{$0.location})
        }
    }
    
    var locationSearchString: String? = nil {
        didSet {
            mapView.addAnnotations(venues.map{$0.location})
        }
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        return mapView
    }()
    
    lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.mapCollectionViewCell.rawValue)
        return collectionView
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
        setupDelegates()
        locationAuthorization()
        addSubviews()
        constrainSubviews()
        loadVenueData()
    }
    
    private func setupDelegates() {
        locationManager.delegate = self
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        venueSearchBar.delegate = self
        locationSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func loadVenueData() {
        VenueAPIClient.manager.getVenue(lat: lat, long: long, venue: venue) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let venues):
                self.venues = venues
                self.collectionView.reloadData()

                DispatchQueue.main.async {
                    for i in venues {
                        self.loadPhotoData(id: i.id)
                    }

                    
                }
                
            }
        }
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
               mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    private func loadPhotoData(id: String) {
        PhotoAPIClient.manager.getPhotos(id: id) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let photos):
                self.photos = photos
                print(photos)
            }
        }
    }
    
    private func locationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            centerViewOnUserLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()

        default:
            locationManager.requestWhenInUseAuthorization()
        }
        
    }

       
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           print("New Location: \(locations)")
       }
       
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           print("Authorization status changed to \(status.rawValue)")
           switch status {
           case .authorizedAlways, .authorizedWhenInUse:
               locationManager.requestLocation()
                centerViewOnUserLocation()
            
           default:
               break
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
       }
}

extension MapViewController: MKMapViewDelegate {}

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchBar {
        case venueSearchBar:
            venueSearchString = searchText
            
        case locationSearchBar:
            locationSearchString = searchText
        default:
            print("Huh, wasn't expecting that")
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        switch searchBar {
        case venueSearchBar:
            locationSearchBar.resignFirstResponder()
            locationSearchBar.showsCancelButton = false
            venueSearchBar.showsCancelButton = true
            return true
        case locationSearchBar:
            venueSearchBar.resignFirstResponder()
            venueSearchBar.showsCancelButton = false
            locationSearchBar.showsCancelButton = true
            return true
        default:
            print("Huh, didn't expect that")
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        
        switch searchBar {
        case venueSearchBar:
            print(searchBar.text ?? "Nothing")
        case locationSearchBar:
            print("hi")
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = locationSearchBar.text
            let activeSearch = MKLocalSearch(request: searchRequest)
            activityIndicator.stopAnimating()
            activeSearch.start { (response, error) in
                if let response = response {
                    let annotations = self.mapView.annotations
                    self.mapView.removeAnnotations(annotations)
                    
                    self.lat = response.boundingRegion.center.latitude
                    self.long = response.boundingRegion.center.longitude
                    
                    let newAnnotation = MKPointAnnotation()
                    newAnnotation.title = self.locationSearchBar.text
                    newAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
                    self.mapView.addAnnotation(newAnnotation)
                    let coordinateRegion = MKCoordinateRegion.init(center: newAnnotation.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                } else {
                    print(error)
                }
            }
        default:
            print("Huh, didn't expect that")
        }
    }
}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.mapCollectionViewCell.rawValue, for: indexPath) as? MapCollectionViewCell else {return UICollectionViewCell()}
        
        cell.backgroundColor = .white
        return cell
    }
    
    
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenheight / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}


extension MapViewController {
    private func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(venueSearchBar)
        view.addSubview(locationSearchBar)
        mapView.addSubview(collectionView)
    }
    
    private func constrainSubviews() {
        constrainMapView()
        constrainVenueSearchBar()
        constrainLocationSearchBar()
        constrainCollectionView()
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
    
    private func constrainCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [collectionView.leadingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor),
         collectionView.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
         collectionView.heightAnchor.constraint(equalToConstant: 150)].forEach{$0.isActive = true}
    }
    
    
}

