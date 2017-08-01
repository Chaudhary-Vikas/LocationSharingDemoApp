//
//  LocationMapViewController.swift
//  LocationSharingDemoApp
//
//  Created by Vikas Chaudhary on 01/08/17.
//  Copyright © 2017 CHDSEZ301972DADM. All rights reserved.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController,MKMapViewDelegate {
    var currentPlacemark:CLPlacemark?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    var location : Location!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
            
        }
        mapView.delegate = self
        if #available(iOS 9.0, *){
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
        self.showMapPinLocation()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showDirection(_ sender: Any) {
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        let directionRequest = MKDirectionsRequest()
        
        //Set the source and destination of the route
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark : currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = MKDirectionsTransportType.automobile
        //calculate the directions
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (routeResponse, routeError) -> Void in
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print(routeError)
                    
                }
                return
            }
            let route = routeResponse.routes[0]
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    
    func showMapPinLocation() {
        let geoLocator = CLGeocoder()
        geoLocator.geocodeAddressString(location.address, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error)
                return
            }
            if let placemarks = placemarks {
                
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                let annotation = MKPointAnnotation()
                annotation.title = self.location.name
                annotation.subtitle = self.location.address
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
                
            }
            
        })
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        var annotationView : MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        let leftIconView = UIImageView(frame :CGRect.init(x: 0, y: 0, width: 53, height: 53))
//        leftIconView.image = UIImage(data: location.image! as Data)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
