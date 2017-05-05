//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Nuruddin on 5/5/17.
//  Copyright © 2017 IUTlab. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var avatarImage: UIImageView!
    var selectedImage : UIImage?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = UIColor.white
        usernameTextField.textColor = .white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)]
        )
        
        let usernameBottomLayer = CALayer()
        usernameBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        usernameBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        usernameTextField.layer.addSublayer(usernameBottomLayer)
        
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)]
        )
        
        let emailBottomLayer = CALayer()
        emailBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        emailBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        emailTextField.layer.addSublayer(emailBottomLayer)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)]
        )
        let passwordBottomLayer = CALayer()
        passwordBottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        passwordBottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        
        passwordTextField.layer.addSublayer(passwordBottomLayer)
        signUpButton.isEnabled = false
        
        avatarImage.layer.cornerRadius = 40
        avatarImage.clipsToBounds = true
        avatarImage.isUserInteractionEnabled = true
       
        avatarImage.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView)))
        handleTextField()
        
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signUpButton.isEnabled = false
                return
        }
        
        signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func signUp_onClick(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: "gs://instagram-clone-c7fd0.appspot.com").child("profile_image").child(uid!)
            if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    
                    self.setUserInfomation(profileImageUrl: profileImageUrl!, username: self.usernameTextField.text!, email: self.emailTextField.text!, uid: uid!)
                })
            }
        })
        
    }
    
    func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
        self.performSegue(withIdentifier: "moveToTabBar2", sender: nil)
    }
    
    @IBAction func dismiss_onClick(_ sender: UIButton) {
        dismiss(animated:true, completion:nil)
        
    }
    
   
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            avatarImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
