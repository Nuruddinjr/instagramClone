//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Nuruddin on 5/5/17.
//  Copyright © 2017 IUTlab. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!

    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    
    }
    
    
    func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)

        
    }
    
   
    @IBAction func shareButton_touchUpInside(_ sender: UIButton) {
        ProgressHUD.show("Waiting....", interaction: false)
        if let shareImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(shareImg, 0.6){
            let photoID = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference(forURL:Config.STORAGE_ROOT_REF).child("posts").child(photoID)
            storageRef.put(imageData, metadata: nil, completion:{
                (metadata, error) in
                if error != nil{
                    return
                }
                let photoURL = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoURL: photoURL!)
                
            })
            
        } else{
            ProgressHUD.showError("Image is empty")
        }

    }

    
    func sendDataToDatabase(photoURL: String){
        let ref = FIRDatabase.database().reference()
        let postsReference = ref.child("posts")
        let newPostID = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostID)
        newPostReference.setValue(["photoURL":photoURL], withCompletionBlock: {
        (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            })
        
    }
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
