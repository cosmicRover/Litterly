//
//  ContainerViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/22/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import Firebase

//holds all the pages that we need to use in our side menu

class ContainerController: UIViewController{
    
    // MARK: - Properties
    
    //for menu logic
    var menuController: MenuController!
    
    //for the vc that we will show
    var centerController: UIViewController!
    
    //is gthe menu currently expanded
    var isExpanded = false
    
    //the blur effect that will be applied to the container view and then be removed
    let blurEffect = UIBlurEffect(style: .regular)
    var blurEffectView: UIVisualEffectView!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHomeController()
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.centerController.view.frame
    }
    
    //modifying the bar style, called with setStatusBarAppearenceUpdate()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    // MARK: - Handlers
    
    
    //set the home controller for our slide menu using a navigationController and rootVC
    func configureHomeController(){
        let homeController = MapsViewController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        
        //adding controller as a child and setting the parent to self
        addChild(centerController)
        centerController.didMove(toParent: self)
        
    }
    
    //configure the actual menu, configure only once
    func configureMenuController(){
        if menuController == nil{
            //add menu controller
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            print("Did add menu controller")
        }
    }
    
    //animate the menu sliding in and out
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?){
        
        if shouldExpand{
            //show menu
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 287
                
                //self.centerController.view.isUserInteractionEnabled = false
                
                //adding the blur effect
                self.centerController.view.addSubview(self.blurEffectView)
                
                //add the gesture so user can tap to compress the panel
                self.addGestureToBlurView()
                
            }, completion: nil)
        } else {
            //hide it
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                
                self.centerController.view.frame.origin.x = 0
                
                //self.centerController.view.isUserInteractionEnabled = true
                
                //removing the blur effect
                self.blurEffectView.removeFromSuperview()
                
            }) { (_) in
                
                guard let menuOption = menuOption else {return}
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        //also animate the status bar
        animateStatusBar()
    }
    
    //add a gesture recognizer and a target
    func addGestureToBlurView(){
        let tapGesture = UITapGestureRecognizer()
        
        blurEffectView.addGestureRecognizer(tapGesture)
        
        tapGesture.addTarget(self, action: #selector(compressPanel))
    }
    
    //calls handleMenuToggle to compress the menu
    @objc func compressPanel(){
        handleMenuToggle(forMenuOption: nil)
    }
    
    //tracks what menu option is currently selected, call your vc here
    func didSelectMenuOption(menuOption: MenuOption){
        
        switch menuOption{
            
        case .Meetups:
            //call destination your VC here
            print("show meetup")
            
            let meetupVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeetupVC") as UIViewController
            self.present(UINavigationController(rootViewController: meetupVC), animated: true, completion: nil)
            
        case .Profile:
            print("show profile")
            
            let profileVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as UIViewController
            self.present(UINavigationController(rootViewController: profileVC), animated: true, completion: nil)
            
        case .Logout:
            print("log user out")
            
            do {
                try Auth.auth().signOut()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let introVc = storyBoard.instantiateViewController(withIdentifier: "IntroPageVC")
                
                self.present(introVc, animated: true, completion: nil)
                
            } catch {
                print("couldn't sign out")
            }

        case .Settings:
            print("show settings")
        }
    }
    
    //animates the sattus bar by modifying it with the override funcs
    func animateStatusBar(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.setNeedsStatusBarAppearanceUpdate()
            
        }, completion: nil)
    }
    
}


//determines if the menu is currently expanded or not and call thge respected funcs accordingly. Conforms to our protocol home controller delegate
extension ContainerController: HomeControllerDelegate{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?){
        if !isExpanded{
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
    
    
}
