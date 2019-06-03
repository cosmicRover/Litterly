//
//  SharedValues.swift
//  litterly
//
//  Created by Joy Paul on 5/13/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class SharedValues{
    
    private init() {}
    static let sharedInstance = SharedValues()
    
    let db = Firestore.firestore()
    
    var tappedArrayElementDict:TrashDataModel!
    
    
    var currentUserDisplayName = Auth.auth().currentUser?.displayName
    var currentUserEmail = Auth.auth().currentUser?.email
    var currentUserProfileImageURL = Auth.auth().currentUser?.photoURL?.absoluteString
    
}
