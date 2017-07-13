//
//  TripViewController.swift
//  TripCard
//
//  Created by Simon Ng on 8/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Parse

class TripViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TripCollectionCellDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    private var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // Make the colleciton view transparent
        collectionView.backgroundColor = UIColor.clear
     
        if UIScreen.main.bounds.size.height == 568.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 330.0)
        }
        
        // Load trip data from the Parse cloud
        loadTripsFromParse()
        let tripObject = PFObject(className: "Trip")
        //        tripObject.objectId = tripId
        tripObject["city"] = "Mumbai"
        tripObject["country"] = "India"
        //        tripObject["featuredImage"] = featuredImage
        tripObject["price"] = 1500
        tripObject["totalDays"] = 4
        tripObject["isLiked"] = true
        
        tripObject.saveInBackground(block: { (success, error) -> Void in
            if (success) {
                print("Successfully updated the trip")
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error"))")
            }
        })
        
        
        // Setup swipe gesture
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUpRecognizer.direction = .up
        swipeUpRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(swipeUpRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TripCollectionViewCell
        
        // Configure the cell
        cell.cityLabel.text = trips[indexPath.row].city
        cell.countryLabel.text = trips[indexPath.row].country
        
        // Load image in background
        cell.imageView.image = UIImage()
        if let featuredImage = trips[indexPath.row].featuredImage {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let tripImageData = imageData {
                    cell.imageView.image = UIImage(data: tripImageData)
                }
            })
        }
        
        cell.priceLabel.text = "$\(String(trips[indexPath.row].price))"
        cell.totalDaysLabel.text = "\(trips[indexPath.row].totalDays) days"
        cell.isLiked = trips[indexPath.row].isLiked
        cell.delegate = self
        
        // Apply round corner
        cell.layer.cornerRadius = 4.0
        
        return cell
    }
    
    // MARK: - TripCollectionCellDelegate methods
    
    func didLikeButtonPressed(cell: TripCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            trips[indexPath.row].isLiked = trips[indexPath.row].isLiked ? false : true
            cell.isLiked = trips[indexPath.row].isLiked
            
            // Update the trip on Parse
            trips[indexPath.row].toPFObject().saveInBackground(block: { (success, error) -> Void in
                if (success) {
                    print("Successfully updated the trip")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error"))")
                }
            })
        }
    }
    
    // MARK: Parse-related methods
    
    func loadTripsFromParse() {
        // Clear up the array
        trips.removeAll(keepingCapacity: true)
        collectionView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "Trip")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            
            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    // Convert PFObject into Trip object
                    let trip = Trip(pfObject: object)
                    self.trips.append(trip)
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                }
            }
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func reloadButtonTapped(sender: Any) {
        loadTripsFromParse()
    }
    
    // MARK: - UIGestureRecognizerDelegate methods
    
    
    func handleSwipe(gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: self.collectionView)
        if (gesture.state == UIGestureRecognizerState.ended) {
            if let indexPath = collectionView.indexPathForItem(at: point) {
                // Remove trip from Parse, array and collection view
                trips[indexPath.row].toPFObject().deleteInBackground(block: { (success, error) -> Void in
                    if (success) {
                        print("Successfully removed the trip")
                    } else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    self.trips.remove(at: indexPath.row)
                    self.collectionView.deleteItems(at: [indexPath])
                })
            }
        }
    }
}
