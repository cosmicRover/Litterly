//
//  Node.swift
//  Litterly
//
//  Created by Joy Paul on 12/31/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation

//MARK: Description: one way linked list going forward
public class Node{
    var data: IntroPageDataModel
    var next: Node?
    
    init(data: IntroPageDataModel, next: Node?){
        self.data = data
        self.next = next
    }
}
