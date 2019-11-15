//
//  CameraView.swift
//  Litterly
//
//  Created by Joy Paul on 11/14/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    let height:Double
    let width:Double
    
    init(height:Double, width:Double){
        self.height = height
        self.width = width
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cameraIcon = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
    
    lazy var cameraView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
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
        button.setTitle("exit", for: .normal)
        //button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    func setupLayout(){
        self.view.addSubview(cameraView)
        cameraView.addSubview(exitButton)
//        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        //exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
//        exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 8).isActive = true
        
        
    }


}
