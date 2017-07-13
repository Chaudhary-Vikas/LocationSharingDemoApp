//
//  AddDetailsViewController.swift
//  LocationSharingDemoApp
//
//  Created by Vicky on 13/07/17.
//  Copyright © 2017 CHDSEZ301972DADM. All rights reserved.
//

import UIKit
import Parse

class AddDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView : UIImageView?
    @IBOutlet var name : UITextField?
    @IBOutlet var city : UITextField?
    @IBOutlet var address : UITextField?
    @IBOutlet var whether : UITextField?
    @IBOutlet var rating : UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func addPicFromLibrery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let pickerView = UIImagePickerController()
            pickerView.delegate = self
            pickerView.allowsEditing = false
            pickerView.sourceType = .photoLibrary
            
        present(pickerView, animated: true, completion: nil)
        }
    }
    
    @IBAction func addPicFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerView = UIImagePickerController()
            pickerView.allowsEditing = false
            pickerView.sourceType = .camera
            
            present(pickerView, animated: true, completion: nil)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView?.image = selectedImage
            imageView?.contentMode = .scaleAspectFill
            imageView?.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveData() {
        
        let tripObject = PFObject(className: "LocationDetail")
        //        tripObject.objectId = tripId
        tripObject["city"] = city?.text
        tripObject["address"] = address?.text
        //        tripObject["featuredImage"] = featuredImage
        tripObject["whether"] = whether?.text
        tripObject["rating"] = rating?.text
        tripObject["name"] = name?.text
        
        tripObject.saveInBackground(block: { (success, error) -> Void in
            if (success) {
                print("Successfully updated the trip")
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error"))")
            }
        })
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
