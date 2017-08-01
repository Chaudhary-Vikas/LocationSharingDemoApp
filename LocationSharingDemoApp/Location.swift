//
//  Location.swift
//  LocationSharingDemoApp
//
//  Created by Vikas Chaudhary on 31/07/17.
//  Copyright © 2017 CHDSEZ301972DADM. All rights reserved.
//

import UIKit
import Parse

struct Location {
    var locationId = ""
    var name = ""
    var address = ""
    var whether = ""
    var featuredImage: PFFile?
    var rating = ""
    
    init(locationId: String, name: String, address: String, whether: String,featuredImage: PFFile!, rating: String ) {
        self.locationId = locationId
        self.name = name
        self.address = address
        self.whether = whether
        self.featuredImage = featuredImage
        self.rating = rating
        
    }
    
    init(pfObject: PFObject) {
        self.locationId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.address = pfObject["address"] as! String
        self.whether = pfObject["whether"] as! String
        self.featuredImage = pfObject["featuredImage"] as? PFFile
        self.rating = pfObject["rating"] as! String
        
    }
    
    func toPFObject() -> PFObject {
        let locationObject = PFObject(className: "LocationDetail")
        locationObject.objectId = locationId
        locationObject["name"] = name
        locationObject["address"] = address
        locationObject["whether"] = whether
        locationObject["featuredImage"] = featuredImage
        locationObject["rating"] = rating
        
        
        return locationObject
    }
}
