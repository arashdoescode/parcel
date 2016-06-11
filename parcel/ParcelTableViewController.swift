//
//  GoSendController.swift
//  customTableView
//
//  Created by Maxim Nikolaevich on 05.06.16.
//  Copyright © 2016 Absalt. All rights reserved.
//

import UIKit
import GoogleMaps

class ParcelTableViewController: UITableViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    private var startCoordinate: CLLocationCoordinate2D?
    private var endCoordinate: CLLocationCoordinate2D?
    private var isEditingStartCoordinate: Bool = false
    private var isEditingEndCoordinate: Bool = false
    private var suggestedRoute: PXGoogleDirectionsRoute? = nil
    
    let heightOfHeader: CGFloat = 40
    
    var tableViewCell = GMapTableViewCell()
    let from = [
        "pick",
        "",
        "contact"
    ]
    //    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 80
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let nextItem = UIBarButtonItem.init(title: "Next",
                                            style: .Done,
                                            target: self,
                                            action: #selector(self.nextButtonPressed(_:)))
        nextItem.enabled = false
        self.navigationItem.rightBarButtonItem = nextItem
    }
    
    
    func nextButtonPressed(sender: UIBarButtonItem) {
        // TODO code here
        //This will go to the MAPS
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(section == 0)
        {
            return 1
        }
        else
        {
            
            return 3
        }
        
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let width = tableView.frame.size.width;
        let header: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: heightOfHeader))
        header.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel.init(frame: CGRect.init(x: 40, y: 0, width: width - 40, height: heightOfHeader))
        
        label.textColor = UIColor.darkGrayColor()
        //        label.font = UIFont(name: "Avenir-next", size: 15)
        
        
        if section == 0 {
            label.text = "DRIVERS NEAR ME"
        } else if section == 1 {
            label.text = "FROM"
        } else {
            label.text = "TO"
        }
        
        
        
        
        header.addSubview(label)
        return header
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
            
            let reuseIdentifier = "maps"
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GMapTableViewCell
            cell.locationManager.delegate = self
            cell.locationManager.requestAlwaysAuthorization()
            cell.locationManager.requestWhenInUseAuthorization()
            cell.mapView.delegate = self
            cell.mapView.myLocationEnabled = true
            cell.mapView.settings.myLocationButton = true
            
            // Draw the waypoints on the map
            if let route = self.suggestedRoute {
                route.drawOnMap(cell.mapView)
                // You can also draw those with custom color and strokeWidth
//                route.drawOnMap(cell.mapView, strokeColor: <#T##UIColor#>, strokeWidth: <#T##Float#>)
            }
            
            return cell
            
        } else if (indexPath.section == 1) {
            return sectionOneAndTwo(indexPath)
            
        } else {
            return sectionOneAndTwo(indexPath)
        }
        
    }
    
    func sectionOneAndTwo(indexPath: NSIndexPath) -> UITableViewCell{
        
        var reuseIdentifier = "pickAlocation"
        if (indexPath.row == 1) {
            reuseIdentifier = "locationDetails"
        } else if (indexPath.row == 2) {
            reuseIdentifier = "contactPerson"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GMapTableViewCell
        
        if (indexPath.row == 0) {
            // update label 'pick a location'
//            cell.pickALocationLabel.text = 
            
        }
        // Configure the cell...
        return cell
        
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            
            return 250;
            
        }
        else
        {
            
            return 80;
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let selected = 2
            print(selected)
            
        case 1:
            let selected = indexPath.row
            if (selected == 0) {
                autoCompleteGoogle()
                self.isEditingStartCoordinate = true
            } else if (selected == 2) {
                self.performSegueWithIdentifier("contact", sender: selected)
            } else {
                print(selected)
            }
        case 2:
            let selected = indexPath.row
            if (selected == 0) {
                autoCompleteGoogle()
                self.isEditingEndCoordinate = true
            } else if (selected == 2) {
                self.performSegueWithIdentifier("contact", sender: selected)
            } else {
                print(selected)
            }
        default :
            print("Number out of range")
        }
        
        
    }
    
    func autoCompleteGoogle() {
        let autocompletecontroller = GMSAutocompleteViewController()
        autocompletecontroller.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .Establishment  //suitable filter type
//        filter.country = "MY"  //appropriate country code
        filter.country = "NL"
        autocompletecontroller.autocompleteFilter = filter
        self.presentViewController(autocompletecontroller, animated: true, completion: nil)
    }
    
    func calculateTheRouteIfNeeded() {
        if let startCoordinate = self.startCoordinate, let endCoordinate = self.endCoordinate {
            // Init the Direcation library with two coordinates to fetch the routes by Google directions api
            let directionsAPI = PXGoogleDirections(apiKey: "AIzaSyBBRErhIWnLSZVDY9UruFQlbn58PsDTVB0",
                                                   from: PXLocation.CoordinateLocation(startCoordinate),
                                                   to: PXLocation.CoordinateLocation(endCoordinate))
            // Fetch the routes
            directionsAPI.calculateDirections({ response in
                switch response {
                case .Error:
                    // Oops, something bad happened, see the error object for more information
                    break
                case .Success(let result):
                    // Autoselect the first one to be displayed on the map
                    self.suggestedRoute = result.1.first
                    // Reload the tableView to trigger the mapCell draw the waypoints on map
                    self.tableView.reloadData()
                    break
                }
            })
        }
    }
}


// Google Autocomplete

extension ParcelTableViewController: GMSAutocompleteViewControllerDelegate{
    
    // This is where I need to properly select the cell
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        
        //         let firstLocationCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as? GMapTableViewCell
        //
        //        let secondLocationCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as? GMapTableViewCell
        // Store the coordinate as the start
        if  self.isEditingStartCoordinate {
            self.isEditingStartCoordinate = false
            self.startCoordinate = place.coordinate
        }
        // Store the coordinate as the end
        if self.isEditingEndCoordinate {
            self.isEditingEndCoordinate = false
            self.endCoordinate = place.coordinate
        }
        
        self.calculateTheRouteIfNeeded()

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // To handle error
        print(error)
        
    }
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
}












