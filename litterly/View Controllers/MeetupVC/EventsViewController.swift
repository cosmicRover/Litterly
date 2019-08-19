//
//  EventsViewController.swift
//  Litterly
//
//  Created by Joyce Huang on 4/25/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class OrganicMeetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var embeddedTableview: UITableView!
    var data = ["Organic Meetup", "Metal Meetup", "Plastic Meetup"]
    var addressData = ["14 st Union Sq", "23rd street, Baruch college", "sdf"]
    let indentifier = "CardContentTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embeddedTableview.dataSource = self
        embeddedTableview.delegate = self
        embeddedTableview.separatorColor = UIColor.textWhite
        
        embeddedTableview.rowHeight = UITableView.automaticDimension
        embeddedTableview.estimatedRowHeight = 100
        
    }
    
    // MARK: - TABLE VIEW DELEGATE & DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
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
        cell.eventAddressLabel.text = addressData[indexPath.row]
        cell.eventNameLabel.text = data[indexPath.row]
        
        
        return cell
    }
    
    //this is where we would call the map screen to view the marker that was selected for meetup
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
