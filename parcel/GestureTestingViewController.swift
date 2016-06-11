//
//  GestureTestingViewController.swift
//  parcel
//
//  Created by Arash on 6/11/16.
//  Copyright © 2016 Arash. All rights reserved.
//

import UIKit
import GoogleMaps

class GestureTestingViewController: UIViewController, GMSMapViewDelegate {

    let locationManager = CLLocationManager()
    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.settings.myLocationButton = true

        let gesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GestureTestingViewController.swipe(_:)))
        view.addGestureRecognizer(gesture)
        let path = GMSMutablePath()
        path.addLatitude(3.1970044, longitude:101.7389365)
        path.addLatitude(3.2058354, longitude:101.729536)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = mapView
        
    }
    
    
    func swipe(swipeGes: UISwipeGestureRecognizer) {
        if swipeGes.direction == .Up {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                //set frame of bottom view to top of screen (show 100%)
            })
        }
        else if swipeGes.direction == .Down {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                //set frame of bottom view to bottom of screen
            })
        }
    }
  
}

extension GestureTestingViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
        }
    }
}

