//
//  ConnectToUsViewController.swift
//  CTC
//
//  Created by Jaldeep Patel on 2021-06-23.
//  Copyright © 2021 Nirav Bavishi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ConnectToUsViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: - Outlet
    @IBOutlet var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    //MARK: - Lifcycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        
        //Coordinates of Connect to The Core
        let latitude: CLLocationDegrees = 43.484677
        let longitude: CLLocationDegrees = -79.643007
        
        //Set coordinate and span
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        //Set region
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        //Add pin on map
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        pin.title = "Connect To The Core"
    }
    
    
    //MARK: - IBActions
    @IBAction func instagramButtontapped(_ sender: UIButton) {
       UIApplication.shared.open(URL(string: "https://www.instagram.com/connecttothecore/")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/Connect-To-The-Core-Inc-244517470006/?ref=bookmarks")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func youtubeButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.youtube.com/channel/UCWjLdrHSw6nQDYXrCWQw9IA?view_as=subscriber")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func linkedInButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.linkedin.com/uas/login?session_redirect=https%3A%2F%2Fwww.linkedin.com%2Fcompany%2F802137%2Fadmin%2F")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func soundCloudButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://soundcloud.com/teresa-easler")!, options: [:], completionHandler: nil)
    }
    
}
