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
    @IBOutlet var contactLabel1: UILabel!
    @IBOutlet var contactLabel2: UILabel!
    @IBOutlet var purchaseButton: UIButton!
    
    let manager = CLLocationManager()
    
    //MARK: - Lifcycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
    }
    
    //MARK: - Map Rendering
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

    //Set up and style the elements
    func setupElements() {
        
        //Set labels texts
        contactLabel1.text = "To order multiple copies of the books,"
        contactLabel2.text = "Send us an email at info@connecttothecore.com"
        
        //Style purchase button
        Utilities.styleButton(purchaseButton)
        Utilities.addShadowToButton(purchaseButton)
        
        //Style mapView
        mapView.layer.borderColor = Utilities.primaryTextColor.cgColor
        mapView.layer.borderWidth = 1
    }
    
    
    //MARK: - IBActions
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.201dayachievementprinciple.com/#section-1586207225653")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func instagramButtontapped(_ sender: UIButton) {
       UIApplication.shared.open(URL(string: "https://www.instagram.com/201dayachievementprinciple/")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/groups/375234539714492/")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func youtubeButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.youtube.com/watch?v=DH4CLrOH9XQ&t=22s")!, options: [:], completionHandler: nil)
    }
}
