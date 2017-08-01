//
//  ShowLocationDetailViewController.swift
//  LocationSharingDemoApp
//
//  Created by Vikas Chaudhary on 01/08/17.
//  Copyright © 2017 CHDSEZ301972DADM. All rights reserved.
//

import UIKit
import MapKit
class ShowLocationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var locationDetailImageView : UIImageView!
    @IBOutlet var locationDetailTableView : UITableView!
    @IBOutlet var mapView : MKMapView!
    
    var location : Location!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showAnnotationOnFooterMap()
        
        self.locationDetailImageView.image = UIImage()
        if let featuredImage = location.featuredImage {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let tripImageData = imageData {
                    self.locationDetailImageView.image = UIImage(data: tripImageData)
                }
            })
        }
        locationDetailTableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.2)
        locationDetailTableView.separatorColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.8)
        
        // Add gesture recognizer on map view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        self.mapView.addGestureRecognizer(tapGestureRecognizer)
        
        
        // hide footer view of Table
        //        detailTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //set title for navigation bar
        title = location.name
        
        //crete dynamic height cell
        locationDetailTableView.estimatedRowHeight = 36.0
        locationDetailTableView.rowHeight = UITableViewAutomaticDimension
    }
    func showAnnotationOnFooterMap() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location.address, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    
                    annotation.coordinate = location.coordinate
                    
                    self.mapView.addAnnotation(annotation)
                    
                    //set zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                    
                }
                
            }
            
            
        })
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showMap() {
        performSegue(withIdentifier: "mapController", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "locationDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ShowLocationDetailTableViewCell
        cell.backgroundColor = UIColor.clear
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = location.name
        case 1:
            cell.fieldLabel.text = "ADDRESS"
            cell.valueLabel.text = location.address
        case 2:
            cell.fieldLabel.text = "WHETHER"
            cell.valueLabel.text = location.whether
        case 3:
            cell.fieldLabel.text = "RATING"
            cell.valueLabel.text = location.rating
            
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showReview" {
//            let destinationSegue = segue.destination as! ReviewController
//            destinationSegue.restaurant = restaurant
//
//        }
      if segue.identifier == "mapController" {
            let destSegue = segue.destination as! LocationMapViewController
            destSegue.location = location
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
