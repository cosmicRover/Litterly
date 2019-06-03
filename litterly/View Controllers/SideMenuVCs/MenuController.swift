//
//  MenuController.swift
//  litterly
//
//  Created by Joy Paul on 4/22/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

private let reusableIdentifier = "MenuOptionCell"

class MenuController: UIViewController{
    
    // MARK: - Properties
    
    var tableView: UITableView!
    
    //also need access to the delegate
    var delegate: HomeControllerDelegate?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    // MARK: - Handlers
    
    //set up the tableview with data source, delegate, cell and constarints
    func configureTableView(){
        
        let imageView = UIImageView()
        
        let userImage = Auth.auth().currentUser?.photoURL?.absoluteString as! String
        let imageUrl = URL(string: userImage)
        let data = try! Data(contentsOf: imageUrl!)
        let image = UIImage(data: data)
        
        let profileImage = ResizeImage(image: image!, targetSize: CGSize(width: 64, height: 64))
        imageView.image = profileImage
        
        //imageView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        imageView.backgroundColor = .white
        view.backgroundColor = UIColor.mainBlue
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
 
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.backgroundColor = UIColor.mainBlue
        tableView.separatorColor = UIColor.containerDividerGrey
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.rowHeight = 73
        tableView.alwaysBounceVertical = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 23).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource{
    
    //returns tableView cell count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //configures cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! MenuOptionCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        //cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
        
        return cell
    }
    
    //returns the selected item on the tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        let cell:MenuOptionCell = tableView.cellForRow(at: indexPath) as! MenuOptionCell
        cell.selectionStyle = .none
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
    
}
