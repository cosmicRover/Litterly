//
//  ProfileViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/5/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usrNameLabel: UILabel!
    @IBOutlet weak var usrCityLabel: UILabel!
    
    
    let segmentedCtrl = UISegmentedControl()
    let subViewForSegCtrl = UIView()
    let activeSegCtrlIndicator = UIView()
    let meetupHistoryLabel = UILabel()
    let containerView = UIView()
    let tableView = UITableView()
    
    //located in the views folder
    let tagVC:UIView = TagViewController().view
    let meetVC:UIView = MeetViewController().view
    let pointsVC:UIView = PointsViewController().view

    let trashTagAtt = ("---", "TRASHTAG")
    let meetupAtt = ("___", "MEETUPS")
    let pointsAtt = ("0", "POINTS")
    
    //firestore instance and the data model vars
    let db = Firestore.firestore()
    var userTaggedTrash = [TrashDataModel]()
    var userCreatedMeetups = [MeetupsQueryModel]()
    var userBasicInfo:UserDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.profileViewGray
        
        configureNavbar()
        
        configureProfilePhoto()
        configureUsrBasicInfo()
        
        setUpSegCtrl()
        configureSegCtrlConstraints()
        customizeSegCtrl()
        
        configureMeetupHistoryLabel()
        
        configureTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        //set the count for the ctrls
        fetchUserTaggedTrash { (count) in
            print(count as! Int)
            self.segmentedCtrl.setTitle("\(count as! Int)\n\(self.trashTagAtt.1)", forSegmentAt: 0)
        }
        
        fetchUserCreatedMeetup { (count) in
            self.segmentedCtrl.setTitle("\(count as! Int)\n\(self.meetupAtt.1)", forSegmentAt: 1)
        }
        
        //gets basic user info and configures them
        fetchUserBasicInfo { (name, neighborhood) in
            self.configureUsrBasicInfo(user: name as! String, on: neighborhood as! String)
        }

    }
    
    //customize the nav bar
    func configureNavbar(){
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue
        navigationController?.navigationBar.backgroundColor = UIColor.mainBlue
        navigationController?.navigationBar.isTranslucent = true
        
        // create the button
        let backImage  = UIImage(named: "white_back_arrow")!.withRenderingMode(.alwaysOriginal)
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.setBackgroundImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(goBackToMap), for: .touchUpInside)
        
        // here where the magic happens, you can shift it where you like
        backButton.transform = CGAffineTransform(translationX: 0, y: 0)
        
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
    
    
    //sets up the labels
    func configureUsrBasicInfo(user name:String = "---", on location:String = "---"){
        
        usrNameLabel.text = "\(name)"
        usrCityLabel.textColor = UIColor.textWhite
        usrCityLabel.text = "\(location)"
        usrCityLabel.textColor = UIColor.textWhite
    }
    
    //sets up the profile pic
    func configureProfilePhoto(){
        
        //provides an image for the imageView using alamofire
        let userImage = Auth.auth().currentUser?.photoURL?.absoluteString as! String
        let imageUrl = URL(string: userImage)
        let data = try! Data(contentsOf: imageUrl!)
        let image = UIImage(data: data)
        
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.isOpaque = false
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.searchBoxTextGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    //creates a segCtrl
    func setUpSegCtrl(){
        
        //sets number of lines of text
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 2
        
        segmentedCtrl.insertSegment(withTitle: "\(trashTagAtt.0)\n\(trashTagAtt.1)", at: 0, animated: true)
        segmentedCtrl.insertSegment(withTitle: "\(meetupAtt.0)\n\(meetupAtt.1)", at: 1, animated: true)
        segmentedCtrl.insertSegment(withTitle: "\(pointsAtt.0)\n\(pointsAtt.1)", at: 2, animated: true)
        
        segmentedCtrl.selectedSegmentIndex = 0
    }
    
    //puts segCtrl inside a view and gives it constraints
    func configureSegCtrlConstraints(){
        segmentedCtrl.translatesAutoresizingMaskIntoConstraints = false
        subViewForSegCtrl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 98)
        subViewForSegCtrl.backgroundColor = UIColor.textWhite
        subViewForSegCtrl.addSubview(segmentedCtrl)
        
        segmentedCtrl.topAnchor.constraint(equalTo: subViewForSegCtrl.topAnchor).isActive = true
        segmentedCtrl.bottomAnchor.constraint(equalTo: subViewForSegCtrl.bottomAnchor).isActive = true
        segmentedCtrl.leftAnchor.constraint(equalTo: subViewForSegCtrl.leftAnchor).isActive = true
        segmentedCtrl.rightAnchor.constraint(equalTo: subViewForSegCtrl.rightAnchor).isActive = true
        segmentedCtrl.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        subViewForSegCtrl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subViewForSegCtrl)
        
        subViewForSegCtrl.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        subViewForSegCtrl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        subViewForSegCtrl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        subViewForSegCtrl.heightAnchor.constraint(equalToConstant: 88).isActive = true
    }
    
    //customizes the view for seg ctrl and the ctrl itself
    func customizeSegCtrl(){
        segmentedCtrl.backgroundColor = UIColor.textWhite
        segmentedCtrl.tintColor = UIColor.textWhite
        
        activeSegCtrlIndicator.translatesAutoresizingMaskIntoConstraints = false
        activeSegCtrlIndicator.backgroundColor = UIColor.mainBlue
        subViewForSegCtrl.addSubview(activeSegCtrlIndicator)
        
        activeSegCtrlIndicator.topAnchor.constraint(equalTo: subViewForSegCtrl.bottomAnchor, constant: -5).isActive = true
        activeSegCtrlIndicator.heightAnchor.constraint(equalToConstant: 8.7).isActive = true
        activeSegCtrlIndicator.leftAnchor.constraint(equalTo: subViewForSegCtrl.leftAnchor).isActive = true
        activeSegCtrlIndicator.widthAnchor.constraint(equalTo: subViewForSegCtrl.widthAnchor, multiplier: 1 / CGFloat(segmentedCtrl.numberOfSegments)).isActive = true
        
        //configure subView's shadow
        subViewForSegCtrl.layer.borderColor = UIColor.searchBoxTextGray.cgColor
        subViewForSegCtrl.layer.shadowColor = UIColor.profileViewGray.cgColor
        subViewForSegCtrl.layer.shadowPath = UIBezierPath(rect: subViewForSegCtrl.bounds).cgPath
        subViewForSegCtrl.layer.shadowOpacity = 0.6
        subViewForSegCtrl.layer.shadowOffset = .zero
        
        //change text attribute for selected/unselected state
        segmentedCtrl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "MarkerFelt-Thin", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.searchBoxTextGray
            ], for: .normal)
        
        segmentedCtrl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "MarkerFelt-Thin", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.containerDividerGrey
            ], for: .selected)
        
        
        let responder = UIResponder()
        
        //we add a listener for the value being changed by passing the responder, an objective-C runtime func for the behavior valueChanged
        segmentedCtrl.addTarget(responder, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    //the history label text and settings
    func configureMeetupHistoryLabel(){
        meetupHistoryLabel.text = "Tag History"
        meetupHistoryLabel.textColor = UIColor.searchBoxTextGray
        meetupHistoryLabel.font = UIFont(name: "MarkerFelt-Wide", size: 12)
        
        meetupHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(meetupHistoryLabel)
        meetupHistoryLabel.topAnchor.constraint(equalTo: subViewForSegCtrl.bottomAnchor, constant: 19).isActive = true
        meetupHistoryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        meetupHistoryLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //meetupHistoryLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: meetupHistoryLabel.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //registering the cell here first
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: "MenuOptionCell")
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl){
        //we animate the buttonBar to go underneath the selected control
        UIView.animate(withDuration: 0.3) {
            self.activeSegCtrlIndicator.frame.origin.x = (self.segmentedCtrl.frame.width / CGFloat(self.segmentedCtrl.numberOfSegments)) * CGFloat(self.segmentedCtrl.selectedSegmentIndex)
        }

        tableView.reloadData()
    }
    
    
    //return each array's respectable .cout
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(segmentedCtrl.selectedSegmentIndex)
        {
        case 0:
            
            meetupHistoryLabel.text = "Tag History"
            
            if userTaggedTrash != nil{
                return userTaggedTrash.count
            } else {
                return 0
            }
            
        case 1:
            
            meetupHistoryLabel.text = "Meetup History"
            
            if userCreatedMeetups != nil{
                return userCreatedMeetups.count
            } else {
                return 0
            }
            
        case 2:
            
            meetupHistoryLabel.text = "Reedem your points"
            
            returnValue = 1
            break
            
        default:
            break
            
        }
        
        return returnValue
    }
    
    //register the cell first and then call it here
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ProfileVCTrashandMeetupsCell", owner: self, options: nil)?.first as! ProfileVCTrashandMeetupsCell
        
        switch(segmentedCtrl.selectedSegmentIndex)
        {
        case 0:
            
            let cell = Bundle.main.loadNibNamed("ProfileVCTrashandMeetupsCell", owner: self, options: nil)?.first as! ProfileVCTrashandMeetupsCell

            cell.lineView.backgroundColor = UIColor.backBarViewGray
            cell.buttonParentView.layer.cornerRadius = 12
            
            if userTaggedTrash[indexPath.row].is_meetup_scheduled {
                cell.buttonParentView.backgroundColor = UIColor.trashOrange
            } else{
                cell.buttonParentView.backgroundColor = UIColor.unselectedGrey
            }
            
            switch userTaggedTrash[indexPath.row].trash_type{
            case "organic" :
                cell.trashTypeButton.setImage(UIImage(named: "icons8-natural-food-100"), for: .normal)
                    break
            case "plastic" :
                cell.trashTypeButton.setImage(UIImage(named: "icons8-plastic-100"), for: .normal)
                    break
            case "metal" :
                cell.trashTypeButton.setImage(UIImage(named: "icons8-gears-100"), for: .normal)
                break
            default:
                print("error")
            }
            
            cell.addressLabel.textColor = UIColor.backBarViewGray
            cell.dateAndTimeLabel.textColor = UIColor.containerDividerGrey
            
            cell.addressLabel.text = userTaggedTrash[indexPath.row].street_address
            
            if userTaggedTrash[indexPath.row].is_meetup_scheduled {
                cell.dateAndTimeLabel.text = "Meetup has been scheduled"
            } else{
                cell.dateAndTimeLabel.text = "Awaiting meetup"
            }
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = Bundle.main.loadNibNamed("ProfileVCTrashandMeetupsCell", owner: self, options: nil)?.first as! ProfileVCTrashandMeetupsCell
            
            cell.lineView.backgroundColor = UIColor.backBarViewGray
            cell.buttonParentView.layer.cornerRadius = 12
            cell.buttonParentView.backgroundColor = UIColor.trashOrange
            cell.addressLabel.textColor = UIColor.backBarViewGray
            cell.dateAndTimeLabel.textColor = UIColor.containerDividerGrey
            
            switch userCreatedMeetups[indexPath.row].type_of_trash{
            case "organic" :
                cell.trashTypeButton.setImage(UIImage(named: "icons8-natural-food-100"), for: .normal)
                break
            case "plastic" :
                cell.trashTypeButton.setImage(UIImage(named: "icons8-plastic-100"), for: .normal)
                break
            case "metal" :
                cell.trashTypeButton.setImage(UIImage(named: "icons8-gears-100"), for: .normal)
                break
            default:
                print("error")
            }
            
            cell.addressLabel.text = userCreatedMeetups[indexPath.row].meetup_address
            cell.dateAndTimeLabel.text = userCreatedMeetups[indexPath.row].meetup_date_time
            
            cell.selectionStyle = .none
            return cell
            
        case 2:
            
            let cell = Bundle.main.loadNibNamed("RedeemPointsCell", owner: self, options: nil)?.first as! RedeemPointsCell
            
            cell.redeemButton.layer.cornerRadius = 12
            
            cell.selectionStyle = .none
            return cell
            
        default:
            break
            
        }
        
        cell.selectionStyle = .none
         return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }

}
