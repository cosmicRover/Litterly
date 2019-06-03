//
//  UnscheduledMarkerWindow.swift
//  litterly
//
//  Created by Joy Paul on 4/28/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//
import UIKit

class UnscheduledMarkerInfoWindow: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userActionButton: UIButton!
    
    let alertService = AlertService()
    
    //button's function
    @IBAction func onButtonTap(_ sender: UIButton) {
        let alert = alertService.alertForSchedule()
//        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //loads view from xib file
    func loadView() -> UnscheduledMarkerInfoWindow{
        let customInfoWindow = Bundle.main.loadNibNamed("UnscheduledMarkerInfoWindow", owner: self, options: nil)?[0] as! UnscheduledMarkerInfoWindow
        
        return customInfoWindow
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
}
