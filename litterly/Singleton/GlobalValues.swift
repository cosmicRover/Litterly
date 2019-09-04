//
//  GlobalValues.swift
//  Litterly
//
//  Created by Joy Paul on 9/4/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import Firebase

struct GlobalValues {
    
    //used to help pass values to the other VC and it also sorts the array by is_meetup_scheduled with false being in the top rows
    static var trashModelArrayBuffer:[TrashDataModel]!{
        didSet{
            trashModelArrayBuffer = GlobalValues.trashModelArrayBuffer.sorted(by: { !$0.is_meetup_scheduled  && $1.is_meetup_scheduled })
        }
    }
    
    static var tappedArrayElementDict:TrashDataModel!
    static var db = Firestore.firestore()
    static var currentUserDisplayName = Auth.auth().currentUser?.displayName
    static var currentUserEmail = Auth.auth().currentUser?.email
    static var currentUserProfileImageURL = Auth.auth().currentUser?.photoURL?.absoluteString
    
    static var cardVC = CardViewController()
    
    static var nearbyCount:Int! = 0
}
