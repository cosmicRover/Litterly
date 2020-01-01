//
//  IntroVM.swift
//  Litterly
//
//  Created by Joy Paul on 12/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class IntroVM{
    
    // MARK: init values for the three screens
    private let data = BehaviorSubject<[IntroPageDataModel]>(value: [IntroPageDataModel(title: "Hi there,", subtitle: "Welcome to Litterly", graphic: UIImage(named: "blue.png")!, button_text: "holla"), IntroPageDataModel(title: "Tag trash", subtitle: "and earn points!", graphic: UIImage(named: "blue.png")!, button_text: "hi"), IntroPageDataModel(title: "Be a hero", subtitle: "lets save our communities", graphic: UIImage(named: "blue.png")!, button_text: "bonjur")])
    
    //break it up with function and repeat indefinitely on a timer
    init() {
        data.subscribe{event in
            switch event{
            case .next(let next):
                print(next)
            case .error(let error):
                print(error)
            case .completed:
                print("finisehd")
            }
        }
    }
    
    
}
