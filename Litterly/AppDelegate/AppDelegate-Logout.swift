//
//  AppDelegate-Logout.swift
//  Litterly
//
//  Created by Joy Paul on 10/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import Firebase

extension AppDelegate{
    func logoutAndRouteTheUser(){
        do {
            try Auth.auth().signOut()
            self.routeTheUser()
            
        } catch {
            print("couldn't sign out")
        }
    }
}
