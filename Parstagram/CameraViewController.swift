//
//  CameraViewController.swift
//  Parstagram
//
//  Created by stargaze on 3/21/19.
//  Copyright © 2019 blinkous. All rights reserved.
//

import UIKit

// "UIImagePickerControllerDelegate" allows access to camera events, to user the imagePicker, you need the navControllerDelegate too
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
