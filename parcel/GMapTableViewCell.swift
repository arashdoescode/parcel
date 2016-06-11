//
//  GMapTableViewCell.swift
//  GenieTesting
//
//  Created by Arash on 6/7/16.
//  Copyright © 2016 Arash. All rights reserved.
//

import UIKit
import GoogleMaps

class GMapTableViewCell: UITableViewCell, GMSMapViewDelegate  {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: GMSMapView!
    
    
    @IBOutlet var contactPerson: UILabel!
    @IBOutlet var pickALocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension GMapTableViewCell: CLLocationManagerDelegate {
    
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
