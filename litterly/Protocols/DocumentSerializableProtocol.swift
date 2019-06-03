//
//  DocumentSerializableProtocol.swift
//  litterly
//
//  Created by Joy Paul on 4/30/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable{
    init?(dictionary: [String:Any])
}
