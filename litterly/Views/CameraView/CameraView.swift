//
//  CameraView.swift
//  Litterly
//
//  Created by Joy Paul on 11/18/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class CameraView: UIView {
    
    let cameraIcon = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
    let backIcon = UIImage(named: "white_back_arrow")?.withRenderingMode(.alwaysOriginal)
    var height:Double
    var width:Double
    
    lazy var cameraView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    lazy var cameraTitle:UILabel = {
        let label = UILabel()
        label.text = "Take a picture of the trashed area"
        return label
    }()
    
    lazy var subtitle:UILabel = {
        let label = UILabel()
        label.text = "Tap on the camera icon to take a photo"
        return label
    }()
    
    lazy var submitButton:UIButton = {
        let button = UIButton()
        button.setTitle("REPORT TRASH", for: .normal)
        //button.isEnabled = false
        return button
    }()
    
    lazy var exitButton:UIButton = {
        let button = UIButton()
        button.setImage(backIcon, for: .normal)
        //button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupView()
    }
    
    convenience init(frame: CGRect, height:Double, width:Double) {
        self.init(frame: frame)
        self.height = height
        self.width = width
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.backgroundColor = UIColor.red
    }
    
}
