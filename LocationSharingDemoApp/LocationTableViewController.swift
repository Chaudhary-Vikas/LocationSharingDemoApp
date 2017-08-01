//
//  LocationTableViewController.swift
//  LocationSharingDemoApp
//
//  Created by Vikas Chaudhary on 31/07/17.
//  Copyright © 2017 CHDSEZ301972DADM. All rights reserved.
//

import UIKit
import Parse
class LocationTableViewController: UITableViewController {
private var location = [Location]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadTripsFromParse()
//        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadTripsFromParse() {
        // Clear up the array
        location.removeAll(keepingCapacity: true)
//        collectionView.reloadData()
        
        // Pull data from Parse
        let query = PFQuery(className: "LocationDetail")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground { (objects, error) -> Void in
            
            if let error = error {
                print("Error: \(error) \(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    // Convert PFObject into Trip object
                    let location = Location(pfObject: object)
                    self.location.append(location)
                    
                    let indexPath = IndexPath(row: index, section: 0)
//                    self.tableView.insertItems(at: [indexPath])
                }
            }
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTripsFromParse()
        navigationController?.hidesBarsOnSwipe = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return location.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell

        // Configure the cell...
        
        cell.locationNameLabel.text = location[indexPath.row].name
        cell.locationAddressLabel.text = location[indexPath.row].address
        cell.locationWhether.text = location[indexPath.row].whether
//        cell.rat.text = location[indexPath.row].address
        // Load image in background
        cell.thumbnailImageView.image = UIImage()
        if let featuredImage = location[indexPath.row].featuredImage {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let tripImageData = imageData {
                    cell.thumbnailImageView.image = UIImage(data: tripImageData)
                }
            })
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationDetail" {
            
            if let indexpath = tableView.indexPathForSelectedRow {
                let destinationSegue = segue.destination as! ShowLocationDetailViewController
                destinationSegue.location = location[indexpath.row]
                
            }
        }
        //        else if segue.identifier == "addRestaurent" {
        //
        //            if let index = tableView.indexPathForSelectedRow {
        //            let destinationSegue = segue.destination as! AddRestaurentController
        //            destinationSegue.restaurent = restaurants[index.row]
        //
        //            }
        //        }
    }
override func tableView(_ tableView: UITableView, editActionsForRowAt
        indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Social Sharing Button
    let cell = tableView.cellForRow(at: indexPath) as! LocationTableViewCell
//        print(cell.locationNameLabel)
    
        let shareAction = UITableViewRowAction(style:
            UITableViewRowActionStyle.default, title: "Share", handler: { (action,
                indexPath) -> Void in
                let defaultText = "Just travelling at " + cell.locationNameLabel.text!
                
//                var dummyImage = UIImage()
//                var bool = 0
//                if let featuredImage = self.location[indexPath.row].featuredImage {
//                    featuredImage.getDataInBackground(block: { (imageData, error) in
//                        if let tripImageData = imageData {
//                            bool = 1
//                            dummyImage = UIImage(data: tripImageData)!
//
//                        }
//                    })
//                }
//        if  bool == 1 {
                if (cell.thumbnailImageView.image != nil) {
        let activityController = UIActivityViewController(activityItems:
            [defaultText, cell.thumbnailImageView.image!], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
})
// Delete button
                
return [shareAction]
}
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
