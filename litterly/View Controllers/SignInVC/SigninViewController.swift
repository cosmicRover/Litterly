//
//  SigninViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/5/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseUI
import Lottie

class SigninViewController: UIViewController {
    
    let animationView = AnimationView(name: "plant")
    let signInButton = UIButton()
    let db = Firestore.firestore()
    var userDataModel = [UserDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeNavBarClear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpAnimation()
        setUpButton()
    }
    
    func setUpAnimation(){
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        animationView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        animationView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        
    }
    
    func setUpButton(){
        signInButton.backgroundColor = UIColor.mainGreen
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.textColor = UIColor.textWhite
        signInButton.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 20)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        signInButton.widthAnchor.constraint(equalToConstant: 178.15).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 47.67).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        signInButton.addTarget(self, action: #selector(triggerSignIn), for: .touchUpInside)
    }
    
    @objc func triggerSignIn(){
        signInUser()
    }

    
    func makeNavBarClear(){
        let appBar = navigationController?.navigationBar
        
        appBar?.setBackgroundImage(UIImage(), for: .default)
        appBar?.shadowImage = UIImage()
        appBar?.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    //sets up the auth system to sign in/sign up the user
    func signInUser(){
        //init authUI
        let authUI = FUIAuth.defaultAuthUI()
        
        //if authUI is nil, log the error and display alert
        if authUI == nil{
            //log error
            return
        }
        
        //setting authUI's delegate to self
        authUI?.delegate = self
        
        //providers take the sign-in methods that we will use
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI?.providers = providers
        
        //init an access to the authUI VC
        let authViewController = authUI!.authViewController()
        
        //present the authUI VC so the user can log in
        present(authViewController, animated: true, completion: nil)
    }
    
}

//gotta extend FUIAuthDelegate so we can have some callback funcs
extension SigninViewController: FUIAuthDelegate{
    
    //this func is necessary for google and facebook signin
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return FUIAuthPickerViewController(nibName: "AuthPickerViewController",
                                           bundle: Bundle.main,
                                           authUI: authUI)
    }
    
    //this is the call back func after the user signs in, we can get basic user info here
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        
        //if error exits, log the error
        if error != nil{
            //log the error
            return
        } else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let firebaseUserInstance = Auth.auth().currentUser else {return}
            
            let user_id = firebaseUserInstance.email
            let user_name = firebaseUserInstance.displayName!
            let profile_pic_url = firebaseUserInstance.photoURL?.absoluteString as! String
            
            let singletonValues = SharedValues.sharedInstance
            
            singletonValues.currentUserEmail = user_id
            singletonValues.currentUserDisplayName = user_name
            singletonValues.currentUserProfileImageURL = profile_pic_url
            
            
            
            let currentUser = UserDataModel(user_id: user_id!, user_name: user_name, profile_pic_url: profile_pic_url, neighborhood: "")
            
            print(currentUser.dictionary)
            
            //calls func to create user in firestore
            submitUserToFirestore(with: currentUser.dictionary, for: user_id!)
            
            
            let mapsViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerVC")
            
            present(mapsViewController, animated: true, completion: nil)
            
            
        }
        
    }
    
}
