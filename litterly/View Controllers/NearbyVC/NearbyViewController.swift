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
    let trashTagsView = UIView()
    let meetupsView = UIView()
    let trashTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let meetupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        configureNavbar()
        configureParentViews()
        
        trashTagCollectionView.dataSource = self
        trashTagCollectionView.delegate = self
        
        meetupsCollectionView.dataSource = self
        meetupsCollectionView.delegate = self
        
        trashTagCollectionView.register(TrashTagsCollectionViewCell.self, forCellWithReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier)
        meetupsCollectionView.register(TrashTagsCollectionViewCell.self, forCellWithReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier)
        
        conFigureCollectionViews()
        changeCollectionViewLayout()
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
        trashTagsView.addSubview(trashTagCollectionView)
        trashTagCollectionView.backgroundColor = UIColor.mainBlue
        trashTagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trashTagCollectionView.topAnchor.constraint(equalTo: trashTagsView.topAnchor).isActive = true
        trashTagCollectionView.leftAnchor.constraint(equalTo: trashTagsView.leftAnchor).isActive = true
        trashTagCollectionView.rightAnchor.constraint(equalTo: trashTagsView.rightAnchor).isActive = true
        trashTagCollectionView.bottomAnchor.constraint(equalTo: trashTagsView.bottomAnchor).isActive = true
        
        meetupsView.addSubview(meetupsCollectionView)
        meetupsCollectionView.backgroundColor = UIColor.mainBlue
        meetupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        meetupsCollectionView.topAnchor.constraint(equalTo: meetupsView.topAnchor).isActive = true
        meetupsCollectionView.rightAnchor.constraint(equalTo: meetupsView.rightAnchor).isActive = true
        meetupsCollectionView.leftAnchor.constraint(equalTo: meetupsView.leftAnchor).isActive = true
        meetupsCollectionView.bottomAnchor.constraint(equalTo: meetupsView.bottomAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.trashTagCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier, for: indexPath) as! TrashTagsCollectionViewCell
            
            cell.trashImageView.image = UIImage(named: "NoPath - Copy (13)")
            
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrashTagsCollectionViewCell.reuseIdentifier, for: indexPath) as! TrashTagsCollectionViewCell
            
            cell.trashImageView.image = UIImage(named: "NoPath - Copy (13)")
            
            return cell
        }
    }
    
  
}



extension NearbyViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}



extension NearbyViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: trashTagsView.frame.size.width / 3, height: trashTagsView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func changeCollectionViewLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        trashTagCollectionView.collectionViewLayout = layout
        meetupsCollectionView.collectionViewLayout = layout
    }
}


