//
//  JoinAlertViewController.swift
//  litterly
//
//  Created by Joy Paul on 5/20/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import AlamofireImage

class JoinAlertViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var meetupHeader: UILabel!
    @IBOutlet weak var meetupAddress: UILabel!
    @IBOutlet weak var meetupDateAndTime: UILabel!
    @IBOutlet weak var collectionViewHeader: UILabel!
    @IBOutlet weak var attendingUserCollectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    let cornerRadiusValue = 12
    let sharedValue = SharedValues.sharedInstance
    let alertService = AlertService()
    var confirmedUsers:[[String:String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableJoinButton()
        setupColors()
        roundCorners()
        fetchMeetupDetails()

        attendingUserCollectionView.dataSource = self
        attendingUserCollectionView.delegate = self
    }
    
    func disableJoinButton(){
        joinButton.isEnabled = false
        joinButton.setTitleColor(UIColor.lightGray, for: .disabled)
    }
    
    func setupColors(){
        self.view.backgroundColor = UIColor.unselectedGrey.withAlphaComponent(0.35)
        parentView.backgroundColor = UIColor.mainBlue
        meetupHeader.textColor = UIColor.trashOrange
        meetupDateAndTime.textColor = UIColor.joinAlertGrey
        attendingUserCollectionView.backgroundColor = UIColor.mainBlue
        joinButton.backgroundColor = UIColor.mainGreen
        cancelButton.backgroundColor = UIColor.unselectedGrey
    }
    
    func roundCorners(){
        parentView.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = 12
        joinButton.layer.cornerRadius = 12
    }
    
    @IBAction func onCancelTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onJoinTap(_ sender: UIButton) {
        
        let userId = sharedValue.currentUserEmail as! String
        let userPicUrl = sharedValue.currentUserProfileImageURL as! String
        let meetupId = ("\(sharedValue.tappedArrayElementDict.lat)\(sharedValue.tappedArrayElementDict.lon)meetup")
        
        updateConfirmedUsersArray(for: meetupId, with: userId, and: userPicUrl)
        
        self.dismiss(animated: true, completion: showSuccessAlert)
    }
    
    func showSuccessAlert(){
        let alert = alertService.alertForGeneral()
        
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    func fetchMeetupDetails(){
        let meetupId = ("\(sharedValue.tappedArrayElementDict.lat)\(sharedValue.tappedArrayElementDict.lon)meetup")
        
        meetupDetailsFromFirestore(for: meetupId)
    }
    
    //returns 0 if confirmedUsers is nil
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if confirmedUsers != nil{
            return confirmedUsers.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleAttendingCollectionViewCell", for: indexPath) as! PeopleAttendingCollectionViewCell
        
        guard let usersData = confirmedUsers else {return cell}
        
        //gets image from network
        let userImage = usersData[indexPath.row]["user_pic_url"] as! String
        let imageUrl = URL(string: userImage)
        let data = try! Data(contentsOf: imageUrl!)
        let image = UIImage(data: data)
        cell.attendingUserProfileImages.image = image
        
        //rounds and configures the cell
        cell.attendingUserProfileImages.contentMode = .scaleAspectFill
        cell.attendingUserProfileImages.isOpaque = false
        cell.attendingUserProfileImages.layer.borderWidth = 1
        cell.attendingUserProfileImages.layer.masksToBounds = false
        cell.attendingUserProfileImages.layer.borderColor = UIColor.searchBoxTextGray.cgColor
        cell.attendingUserProfileImages.layer.cornerRadius = cell.attendingUserProfileImages.frame.height/2
        cell.attendingUserProfileImages.clipsToBounds = true
        
        return cell
    }
    
    //animates the cells appearing
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
}
