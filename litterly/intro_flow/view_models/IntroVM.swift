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
    
    // MARK: init values for the three screens, get reference to CircularLinkedList and create a dispose bag
    private let initData = Observable.of(IntroPageDataModel(title: "Hi there,", subtitle: "Welcome to Litterly", graphic: UIImage(named: "trash-can.png")!, buttonText: "holla", position: 0), IntroPageDataModel(title: "Tag trash", subtitle: "and earn points!", graphic: UIImage(named: "liberty")!, buttonText: "hi", position: 1), IntroPageDataModel(title: "Be a hero", subtitle: "lets save our communities", graphic: UIImage(named: "building.png")!, buttonText: "bonjur", position: 2))
    private let cll = CircularLinkedList()
    private let disposeBag = DisposeBag()
    public var valueStream: Observable<IntroPageDataModel> {get{return _valueStream()}}
    
    //MARK: During init, insert all the nodes from the Observable to the linked list
    init() {
        initData.subscribe{event in
            switch event{
            case .next(let data):
                if data.position == 2{
                    self.cll.addNodeAfterTail(data: data, isLast: true)
                }else {
                 self.cll.addNodeAfterTail(data: data, isLast: false)
                }
            case .error(let error):
                print(error.localizedDescription)
            case .completed:
                print("completed Linked List insertion")
            }
        }.disposed(by: disposeBag)
    }
    
    
    private func _valueStream() -> Observable<IntroPageDataModel>{
        return Observable.create{observer in
            
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), repeating: DispatchTimeInterval.seconds(1))
            
            let cancelTimer = Disposables.create {
                timer.cancel()
            }
            
            var valueFromCll = self.cll.getFirstNode
            
            timer.setEventHandler{
                if cancelTimer.isDisposed{
                    return
                }
                observer.on(.next(valueFromCll!.data))
                valueFromCll = valueFromCll?.next
            }
            timer.resume()
            
            return cancelTimer
        }
    }
}
