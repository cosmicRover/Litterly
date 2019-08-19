//
//  SearchBarViewController-MapsVC.swift
//  Litterly
//
//  Created by Joy Paul on 4/10/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

extension MapsViewController{
    
    func makeTheNavBarClear(){
        view.bringSubviewToFront(mapView!)
        
        let appBar = navigationController?.navigationBar
        
        appBar?.setBackgroundImage(UIImage(), for: .default)
        appBar?.shadowImage = UIImage()
        appBar?.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func addMenuAndSearchButtonToNavBar(){
        
        let navView = UIView(frame: CGRect(x: 16, y: 5, width: self.view.frame.width - 31, height: 52))
        navView.backgroundColor = UIColor.clear
        navView.translatesAutoresizingMaskIntoConstraints = false
        
        
        // adds the menu UIView
        let menuImageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 43, height: 43))
        menuImageContainerView.backgroundColor = UIColor.textWhite
        menuImageContainerView.layer.cornerRadius = menuImageContainerView.frame.width / 2
        menuImageContainerView.layer.shadowColor = UIColor.searchBoxShadowColor.cgColor
        menuImageContainerView.layer.shadowOpacity = 0.15
        menuImageContainerView.layer.shadowOffset = .zero
        menuImageContainerView.layer.shadowRadius = 10

        let menuImageName = "menu"
        let menuImage = ResizeImage(image: UIImage(named: menuImageName)!, targetSize: CGSize(width: 25, height: 25))
        let menuImageView = UIImageView(image: menuImage)
        menuImageView.clipsToBounds = true
        
        menuImageContainerView.addSubview(menuImageView)
        menuImageView.center.y = menuImageContainerView.center.y
        menuImageView.center.x = menuImageContainerView.center.x
        
        let menuTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleMenuToggle))
        menuImageContainerView.addGestureRecognizer(menuTapGesture)
        menuImageContainerView.isUserInteractionEnabled = true
        navView.addSubview(menuImageContainerView)
        
        
        //adds the search UIView
        let searchContainerView = UIView(frame: CGRect(x: navView.frame.width - 43, y: 0, width: 43, height: 43))
        searchContainerView.backgroundColor = UIColor.textWhite
        searchContainerView.layer.cornerRadius = menuImageContainerView.frame.width / 2
        searchContainerView.layer.shadowColor = UIColor.searchBoxShadowColor.cgColor
        searchContainerView.layer.shadowOpacity = 0.15
        searchContainerView.layer.shadowOffset = .zero
        searchContainerView.layer.shadowRadius = 10
        
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.launchAutocomplete))
        searchContainerView.addGestureRecognizer(searchTapGesture)
        searchContainerView.isUserInteractionEnabled = true
        navView.addSubview(searchContainerView)
        
        let searchImageName = "search"
        let searchImage = ResizeImage(image: UIImage(named: searchImageName)!, targetSize: CGSize(width: 25, height: 25))
        let searchImageView = UIImageView(image: searchImage)
        searchImageView.clipsToBounds = true
        
        searchContainerView.addSubview(searchImageView)
        searchImageView.center.y = menuImageContainerView.center.y
        searchImageView.center.x = menuImageContainerView.center.x
        
        
        //adds the UIViews to the navView
        self.navigationController?.navigationBar.addSubview(navView)
        
    }
    
    //func to expand the side menu
    @objc func handleMenuToggle(){
        delegate?.handleMenuToggle(forMenuOption: nil)

    }
    
    //resizes image
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

