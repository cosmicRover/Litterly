//
//  NearbyViewController.swift
//  litterly
//
//  Created by Joy Paul on 6/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController {
    
    @IBOutlet weak var meetupsCollectionView: UICollectionView!
    @IBOutlet weak var trashCollectionView: UICollectionView!
    
    var meetups = MeetUps.createMeetUps()
    var trashTag = TrashTags.createTrashTags()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trashCollectionView.dataSource = self
        meetupsCollectionView.dataSource = self
        
    }
    
}

extension NearbyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == self.trashCollectionView {
            return trashTag.count
        }
        
        return  meetups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.trashCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashTagsCollectionViewCell", for: indexPath) as! TrashTagsCollectionViewCell
            cell.trashTag = trashTag[indexPath.item]
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetupsCollectionViewCell", for: indexPath) as! MeetupsCollectionViewCell
            cell.meetup = meetups[indexPath.item]
            return cell
        }
        
    }
    
    
    
}
