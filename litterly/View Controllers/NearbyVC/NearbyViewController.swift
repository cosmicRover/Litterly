//
//  NearbyViewController.swift
//  litterly
//
//  Created by Joy Paul on 6/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController {
    
    @IBOutlet var parentView: UIView!
    let trashTagsView = UIView()
    let meetupsView = UIView()
    let trashTagCollectionView = UICollectionView()
    let meetupsCollectionView = UICollectionView()

    override func viewDidLoad() {
        configureNavbar()
        configureParentViews()
//        trashTagCollectionView.dataSource = self
//        trashTagCollectionView.delegate = self
    }
    
    func configureNavbar(){
        
        //removes the bar border color
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.textWhite, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 40)]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Nearby"
        navigationController?.navigationBar.backgroundColor = UIColor.mainBlue
        
        // create the button
        let backImage  = UIImage(named: "white_back_arrow")!.withRenderingMode(.alwaysOriginal)
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setBackgroundImage(backImage, for: .normal)
        //backButton.addTarget(self, action: #selector(goBackToMap), for: .touchUpInside)
        
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
    
    func configureParentViews(){
        
        trashTagsView.frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height/2)
        parentView.addSubview(trashTagsView)
        
        trashTagsView.translatesAutoresizingMaskIntoConstraints = false
        trashTagsView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor).isActive = true
        trashTagsView.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        trashTagsView.rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        trashTagsView.heightAnchor.constraint(equalToConstant: parentView.frame.height / 2 - (self.navigationController?.navigationBar.frame.size.height)!).isActive = true
        trashTagsView.backgroundColor = .yellow
        
        
        meetupsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
        parentView.addSubview(meetupsView)
        
        meetupsView.translatesAutoresizingMaskIntoConstraints = false
        meetupsView.topAnchor.constraint(equalTo: trashTagsView.bottomAnchor).isActive = true
        meetupsView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        meetupsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        meetupsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        meetupsView.backgroundColor = .green
        
    }
    
    //todo: configure the respective collectionViews
    func conFigureCollectionViews(){
        
    }
  
}


