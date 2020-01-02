import UIKit
import RxSwift
import Foundation

func valueStream() -> Observable<Int>{
    return Observable.create{observer in
        
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), repeating: DispatchTimeInterval.seconds(1))
        
        let cancelTimer = Disposables.create {
            timer.cancel()
        }
        
        var val = 0
        
        timer.setEventHandler{
            if cancelTimer.isDisposed{
                return
            }
            observer.on(.next(val))
            val += 1
        }
        timer.resume()
        
        return cancelTimer
    }
}

let stream = valueStream()
stream.subscribe{event in
    switch event {
    case .next(let next):
        print(next)
    case .error(let error):
        print(error.localizedDescription)
    case .completed:
        print("completed")
    }
}

