//
//  ViewController.swift
//  LocationSharingDemoApp
//
//  Created by Vikas Chaudhary on 13/07/17.
//  Copyright © 2017 CHDSEZ301972DADM. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let query = PFQuery(className: "LocationDetail")
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
            print("Error: \(error) \(error.localizedDescription)")
            return
            }
            
            if let objects = objects {
            // Do something
            }
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

