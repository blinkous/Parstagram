//
//  CameraViewController.swift
//  Parstagram
//
//  Created by stargaze on 3/21/19.
//  Copyright © 2019 blinkous. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

// "UIImagePickerControllerDelegate" allows access to camera events, to user the imagePicker, you need the navControllerDelegate too
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        // Create a PF Object that will be a table in the dashboard
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text
        post["author"] = PFUser.current()
        
        // This is saved in a table just for the photos
        // Save the image as a png
        let imageData = imageView.image!.pngData()
        // Create a parse file
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved")
            } else {
                print("bleh")
            }
        }
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        // When the user is done picking a photo, let the app know what they chose
        picker.delegate = self
        // Presents a second screen to user to allow them to edit the photo
        picker.allowsEditing = true
        
        // Picking the image picker's source: if the camera is available, use it, otherwise use the image library
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            // .camera is a swift enum
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    // Once the user selects an image, we want to get that image and place it in the view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        //Resize image for easier uploading to heroku
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        //Set the imageview to the selected image
        imageView.image = scaledImage
        
        // Dismiss the camera view
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
