//
//  MetalMeetupViewController.swift
//  litterly
//
//  Created by Joy Paul on 5/22/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class MetalMeetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var embeddedTableview: UITableView!
    let sharedValues = SharedValues.sharedInstance
    var queriedMeetupArray = [MeetupsQueryModel]()
    let indentifier = "CardContentTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMetalMeetups()
        
        embeddedTableview.dataSource = self
        embeddedTableview.delegate = self
        embeddedTableview.separatorColor = UIColor.textWhite
        
        embeddedTableview.rowHeight = UITableView.automaticDimension
        embeddedTableview.estimatedRowHeight = 100
        
    }
    
    // MARK: - TABLE VIEW DELEGATE & DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if queriedMeetupArray != nil{
            return queriedMeetupArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as! CardContentTableViewCell
        
        //adding color to the barView, icon's parent view and cornering it, giving the labels custom colors
        cell.backBarView.backgroundColor = UIColor.backBarViewGray
        cell.iconParentView.layer.cornerRadius = 12
        cell.iconParentView.backgroundColor = UIColor.trashOrange
        cell.eventAddressLabel.textColor = UIColor.backBarViewGray
        cell.eventNameLabel.textColor = UIColor.containerDividerGrey
        //change the icons image here if you want to
        cell.iconImageButton.setImage(UIImage(named: "icons8-gears-100"), for: .normal)
        
        //passing data to the labels
        cell.eventAddressLabel.text = queriedMeetupArray[indexPath.row].meetup_address
        cell.eventNameLabel.text = queriedMeetupArray[indexPath.row].meetup_date_time
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //this is where we would call the map screen to view the marker that was selected for meetup
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
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
