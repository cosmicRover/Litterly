//
//  SigninVC-Firebase.swift
//  litterly
//
//  Created by Joy Paul on 5/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension SigninViewController{
    
    //creates a user on firestore
    func submitUserToFirestore(with dictionary: [String:Any], for id:String){
        
        db.collection("Users").document("\(id)").setData(dictionary) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
        }
        
    }
}
