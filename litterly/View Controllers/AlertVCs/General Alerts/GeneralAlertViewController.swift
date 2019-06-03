//
//  GeneralAlertViewController.swift
//  litterly
//
//  Created by Joy Paul on 5/21/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import Lottie

class GeneralAlertViewController: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    let animationView = AnimationView(name: "check")
    let okayButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupAnimation()
        //setupOkayButton()
    }
    
    func setupAnimation(){
        animationView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(animationView)
        animationView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        animationView.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 50.0).isActive = true
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 2.5
        animationView.play { (_) in
            print("completed")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func setupOkayButton(){
        okayButton.backgroundColor = UIColor.mainBlue
        okayButton.setTitle("Success", for: .normal)
        okayButton.titleLabel?.textColor = UIColor.textWhite
        okayButton.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        animationView.addSubview(okayButton)
        okayButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        okayButton.heightAnchor.constraint(equalToConstant: 47.67).isActive = true
        okayButton.centerXAnchor.constraint(equalTo: animationView.centerXAnchor).isActive = true
        okayButton.bottomAnchor.constraint(equalTo: animationView.bottomAnchor).isActive = true
        //okayButton.centerYAnchor.constraint(equalTo: animationView.centerYAnchor).isActive = true
    }

}
