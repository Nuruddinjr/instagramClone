//
//  AuthService.swift
//  InstagramClone
//
//  Created by Nuruddin on 5/5/17.
//  Copyright © 2017 IUTlab. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void )
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                //                print(error!.localizedDescription)
                return
            }
            onSuccess()
            
        })
        
    } // function end
    
    static func signUp(email: String,
                       password: String,
                       username: String,
                       imageData: Data,
                       onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void )
    {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                let profileImageUrl = metadata?.downloadURL()?.absoluteString
                
                self.setUserInfomation(profileImageUrl: profileImageUrl!, username: username,  email: email, uid: uid!, onSuccess: onSuccess)
            })
            
            
            
            
        })
        
        
        
    } // function end
    
    
    static func setUserInfomation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
        
        
    }
    
}
