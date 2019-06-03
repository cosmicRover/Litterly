//
//  MeetupViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import Cards

class MeetupViewController: UIViewController {
    
    let sharedValues = SharedValues.sharedInstance
    var organicMeetupCount:Int!
    
    //init a stackView for the cards and configure them
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [organicCardView, plasticCardView, metalCardView])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //organic card
    var organicCardView: Card = {
        let card = CardHighlight()
        
        card.backgroundImage = UIImage(named: "organic_trash")
        card.title = ""
        card.itemTitle = ""
        card.itemSubtitle = ""
        card.textColor = UIColor.unselectedGrey
        card.hasParallax = true
        
        card.buttonText = "Organics"
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        return card
    }()
    
    //plastic card
    var plasticCardView: Card = {
        let card = CardHighlight()
        
        //card.backgroundColor = UIColor.unselectedGrey
        card.backgroundImage = UIImage(named: "plastic_trash")
        card.title = ""
        card.itemTitle = ""
        card.itemSubtitle = ""
        card.textColor = UIColor.unselectedGrey
        card.hasParallax = true
        
        card.buttonText = "Plastic"
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        return card
    }()
    
    //metal card
    var metalCardView: Card = {
        let card = CardHighlight()
        
        //card.backgroundColor = UIColor.unselectedGrey
        card.backgroundImage = UIImage(named: "metal_trash")
        card.title = ""
        card.itemTitle = ""
        card.itemSubtitle = ""
        card.textColor = UIColor.unselectedGrey
        card.hasParallax = true
        
        card.buttonText = "Metal"
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        return card
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.mainBlue
        
        configureNavbar()
        setupLayout()
        actionsForCardViews()
    }
    
    //holds storyBoard IDs for their respective detail VC
    func actionsForCardViews(){
        let organicMeetupDetail:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrganicMeetups") as UIViewController
        organicCardView.shouldPresent(organicMeetupDetail, from: self, fullscreen: false)
        
        let plasticMeetupDetail:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlasticMeetups") as UIViewController
        plasticCardView.shouldPresent(plasticMeetupDetail, from: self, fullscreen: false)
        
        let metalMeetupDetail:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MetalMeetups") as UIViewController
        metalCardView.shouldPresent(metalMeetupDetail, from: self, fullscreen: false)
    }
    
    //give stackView the constraints
    func setupLayout() {
        // Stack View
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25 + ((self.navigationController?.navigationBar.frame.height)!)).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -29).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    //customize the nav bar
    func configureNavbar(){
        
        //removes the bar border color
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.textWhite, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 40)]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Meetups"
        navigationController?.navigationBar.backgroundColor = UIColor.mainBlue
        
        // create the button
        let backImage  = UIImage(named: "white_back_arrow")!.withRenderingMode(.alwaysOriginal)
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setBackgroundImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(goBackToMap), for: .touchUpInside)
        
        // here where the magic happens, you can shift it where you like
        backButton.transform = CGAffineTransform(translationX: 10, y: 0)
        
        // add the button to a container, otherwise the transform will be ignored
        let backButtonContainer = UIView(frame: backButton.frame)
        backButtonContainer.addSubview(backButton)
        let leftNavButtonItem = UIBarButtonItem(customView: backButtonContainer)
        
        // add button shift to the side
        navigationItem.leftBarButtonItem = leftNavButtonItem
    }
    
    //back button onTap() func
    @objc func goBackToMap(){
        self.dismiss(animated: true, completion: nil)
    }

}
