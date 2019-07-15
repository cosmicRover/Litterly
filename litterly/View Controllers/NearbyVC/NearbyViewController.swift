//
//  NearbyViewController.swift
//  litterly
//
//  Created by Joy Paul on 6/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController, UICollectionViewDataSource{
    
    @IBOutlet var parentView: UIView!
    
    // the two views to hold the collectionViews
    let trashTagsView = UIView()
    let meetupsView = UIView()
    
    // the text lables
    let trashTagLabel:UILabel = {
        let label = UILabel()
        label.text = "#trashtags"
        label.textColor = UIColor.textWhite
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        return label
    }()
    
    let meetupLabel:UILabel = {
        let label = UILabel()
        label.text = "Meetups"
        label.textColor = UIColor.textWhite
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        return label
    }()
    
    let nearbyTextLabel:UILabel = {
        let label = UILabel()
        label.text = "Nearby"
        label.textColor = UIColor.textWhite
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "MarkerFelt-Thin", size: 40)
        return label
    }()
    
    //two collectionViews
    let trashTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let meetupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        configureNavbar()
        configureParentViews()
        setupPrecursorToCollectionViews()
        conFigureCollectionViews()
        changeCollectionViewLayout()
    }
    
    //sets the layouts to horizontal
    func changeCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        trashTagCollectionView.collectionViewLayout = layout
        meetupsCollectionView.collectionViewLayout = layout
    }
    
    //sets the data source, delegates and registers the appropriate cells
    func setupPrecursorToCollectionViews(){
        trashTagCollectionView.dataSource = self
        trashTagCollectionView.delegate = self
        
        meetupsCollectionView.dataSource = self
        meetupsCollectionView.delegate = self
        
        trashTagCollectionView.register(TrashTagsCollectionViewCell.self, forCellWithReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier)
        meetupsCollectionView.register(TrashTagsCollectionViewCell.self, forCellWithReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier)
    }
    
    //nav bar is getting inherited from the vc this screen is being called from
    func configureNavbar(){
        
        //removes the bar border color
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue
        
        // create the button
        let backImage  = UIImage(named: "white_back_arrow")!.withRenderingMode(.alwaysOriginal)
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setBackgroundImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(goBackToMap), for: .touchUpInside)
        
        //add the button
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
        
        self.parentView.backgroundColor = UIColor.mainBlue
        
        //nearby text label configuration
        view.addSubview(nearbyTextLabel)
        nearbyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        nearbyTextLabel.topAnchor.constraint(equalTo: self.parentView.safeAreaLayoutGuide.topAnchor).isActive = true
        nearbyTextLabel.leftAnchor.constraint(equalTo: self.parentView.leftAnchor, constant: 24.0).isActive = true
        nearbyTextLabel.rightAnchor.constraint(equalTo: self.parentView.rightAnchor).isActive = true
        
        //trashtag view configuration
        trashTagsView.frame = CGRect(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height/2)
        parentView.addSubview(trashTagsView)
        trashTagsView.translatesAutoresizingMaskIntoConstraints = false
        trashTagsView.topAnchor.constraint(equalTo: nearbyTextLabel.bottomAnchor, constant: 20).isActive = true
        trashTagsView.leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        trashTagsView.rightAnchor.constraint(equalTo: parentView.rightAnchor).isActive = true
        let size = self.parentView.frame.height / 2.5
        trashTagsView.heightAnchor.constraint(equalToConstant: size).isActive = true
        trashTagsView.backgroundColor = UIColor.mainBlue
        
        //trash tag label configuration
        trashTagsView.addSubview(trashTagLabel)
        trashTagLabel.translatesAutoresizingMaskIntoConstraints = false
        trashTagLabel.topAnchor.constraint(equalTo: trashTagsView.topAnchor).isActive = true
        trashTagLabel.leftAnchor.constraint(equalTo: trashTagsView.leftAnchor, constant: 24.0).isActive = true
        trashTagLabel.rightAnchor.constraint(equalTo: trashTagsView.rightAnchor).isActive = true
        
        //meetupview configuration
        meetupsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0 )
        parentView.addSubview(meetupsView)
        meetupsView.translatesAutoresizingMaskIntoConstraints = false
        meetupsView.topAnchor.constraint(equalTo: trashTagsView.bottomAnchor).isActive = true
        meetupsView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        meetupsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        meetupsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        meetupsView.backgroundColor = UIColor.mainBlue
        
        //meetup label label configuration
        meetupsView.addSubview(meetupLabel)
        meetupLabel.translatesAutoresizingMaskIntoConstraints = false
        meetupLabel.topAnchor.constraint(equalTo: meetupsView.topAnchor, constant: 16).isActive = true
        meetupLabel.leftAnchor.constraint(equalTo: meetupsView.leftAnchor, constant: 24.0).isActive = true
        meetupLabel.rightAnchor.constraint(equalTo: meetupsView.rightAnchor).isActive = true
        
    }
    
    //todo: configure the respective collectionViews
    func conFigureCollectionViews(){
        trashTagsView.addSubview(trashTagCollectionView)
        trashTagCollectionView.backgroundColor = UIColor.mainBlue
        trashTagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trashTagCollectionView.topAnchor.constraint(equalTo: trashTagLabel.bottomAnchor).isActive = true
        trashTagCollectionView.leftAnchor.constraint(equalTo: trashTagsView.leftAnchor).isActive = true
        trashTagCollectionView.rightAnchor.constraint(equalTo: trashTagsView.rightAnchor).isActive = true
        trashTagCollectionView.bottomAnchor.constraint(equalTo: trashTagsView.bottomAnchor).isActive = true
        
        meetupsView.addSubview(meetupsCollectionView)
        meetupsCollectionView.backgroundColor = UIColor.mainBlue
        meetupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        meetupsCollectionView.topAnchor.constraint(equalTo: meetupLabel.bottomAnchor).isActive = true
        meetupsCollectionView.rightAnchor.constraint(equalTo: meetupsView.rightAnchor).isActive = true
        meetupsCollectionView.leftAnchor.constraint(equalTo: meetupsView.leftAnchor).isActive = true
        meetupsCollectionView.bottomAnchor.constraint(equalTo: meetupsView.bottomAnchor).isActive = true
    }
    
    //return int based on
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //we can differentiate between the collectionViews and cells configured automatically
        if collectionView == self.trashTagCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier, for: indexPath) as! TrashTagsCollectionViewCell
            
            cell.trashImageView.image = UIImage(named: "plastic-bin")
            cell.overlayView.heightAnchor.constraint(equalToConstant: (self.trashTagCollectionView.frame.height / 3.5)).isActive = true
            
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier, for: indexPath) as! TrashTagsCollectionViewCell
            
            cell.trashImageView.image = UIImage(named: "organic-bin")
            cell.overlayView.heightAnchor.constraint(equalToConstant: (self.meetupsCollectionView.frame.height / 3.5)).isActive = true
            
            return cell
        }
    }
    
  
}


//delegate methods
extension NearbyViewController: UICollectionViewDelegate{
    
    //configure tap here
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


//flow layout customization goes here
extension NearbyViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (parentView.frame.width / 2.1), height: ((parentView.frame.height / 2.5) - (self.parentView.frame.height / 6)))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -16
    }
}


