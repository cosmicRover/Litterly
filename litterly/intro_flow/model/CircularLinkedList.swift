//
//  CircularLinkedList.swift
//  Litterly
//
//  Created by Joy Paul on 12/31/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation

//MARK: Circular linked list implementation for cycling values
public class CircularLinkedList {
    fileprivate var head: Node?
    private var tail: Node?
    
    public var getFirstNode: Node?{
        return head
    }
    
    public func addNodeAfterTail(data: IntroPageDataModel, isLast: Bool = false){
        let newNode = Node(data: data, next: nil)
        
        if let tailNode = tail{
            tailNode.next = newNode
        }else{
            head = newNode
        }

        tail = newNode
        
        if isLast{
            tail!.next = head
        }
    }
    
}
