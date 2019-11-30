//
//  CameraView.swift
//  Litterly
//
//  Created by Joy Paul on 11/14/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
//    var delegate: PassImageDelegate
    
    let height:Double
    let width:Double
    
    let cameraIcon = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
    let backIcon = UIImage(named: "white_back_arrow")?.withRenderingMode(.alwaysOriginal)
    var imagePicker: UIImagePickerController!
    
    lazy var cameraView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    lazy var cameraTitle:UILabel = {
        let label = UILabel()
        let font = UIFont(name: "Marker Felt", size: 20)
        let color = UIColor.textWhite
        let text = "Take a picture of the trashed area"
        let atts:[NSAttributedString.Key : Any] = [
            .font : font as Any,
            .foregroundColor : color,
        ]
        let attText = NSAttributedString(string: text, attributes: atts)
        label.attributedText = attText
        return label
    }()
    
    lazy var subtitle:UILabel = {
        let label = UILabel()
        let font = UIFont(name: "MarkerFelt-Thin", size: 12)
        let color = UIColor.textWhite
        let text = "Tap on the camera icon!"
        let atts:[NSAttributedString.Key : Any] = [
            .font : font as Any,
            .foregroundColor : color,
        ]
        let attText = NSAttributedString(string: text, attributes: atts)
        label.attributedText = attText
        return label
    }()
    
    lazy var cameraButton:UIButton = {
        let button = UIButton()
        button.setImage(cameraIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 76).isActive = true
        button.widthAnchor.constraint(equalToConstant: 101).isActive = true
        button.backgroundColor = UIColor.unselectedGrey
        button.layer.cornerRadius = 12
        return button
    }()
    
    lazy var submitButton:UIButton = {
        let button = UIButton()
        let font = UIFont(name: "Marker Felt", size: 17)
        var color = UIColor.textWhite
        let text = "Report it!"
        var atts:[NSAttributedString.Key : Any] = [
            .font : font as Any,
            .foregroundColor : color,
        ]
        var attText = NSAttributedString(string: text, attributes: atts)
        button.setAttributedTitle(attText, for: .normal)
        
        color = UIColor.lightText
        atts = [
            .font : font as Any,
            .foregroundColor : color,
        ]
        
        attText = NSAttributedString(string: text, attributes: atts)
        button.setAttributedTitle(attText, for: .disabled)
        
        
        
        button.isEnabled = false
        button.backgroundColor = UIColor.mainGreen
        button.layer.cornerRadius = 12
        button.isEnabled = false
        return button
    }()
    
    lazy var exitButton:UIButton = {
        let button = UIButton()
        button.setImage(backIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    
    lazy var imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(named: "blue")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    init(height:Double, width:Double){
        self.height = height
        self.width = width
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.isUserInteractionEnabled = true
        setupLayout()
        addTargets()
    }
}

extension CameraViewController{
    func setupLayout(){
        self.view.addSubview(cameraView)
        cameraView.addSubview(exitButton)
        exitButton.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8)
        ])
        
        cameraView.addSubview(cameraTitle)
        cameraTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraTitle.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 16),
            cameraTitle.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor, constant: 0)
        ])
        
        cameraView.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: cameraTitle.bottomAnchor, constant: 8),
            subtitle.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor, constant: 0)
        ])
        
        cameraView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 52),
            submitButton.leftAnchor.constraint(equalTo: cameraView.leftAnchor, constant: 24),
            submitButton.rightAnchor.constraint(equalTo: cameraView.rightAnchor, constant: -24),
            submitButton.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: -20)
        ])
        
        cameraView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -8),
            imageView.leftAnchor.constraint(equalTo: cameraView.leftAnchor, constant: 24),
            imageView.rightAnchor.constraint(equalTo: cameraView.rightAnchor, constant: -24)
        ])
       
        imageView.addSubview(cameraButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    func addTargets(){
        exitButton.addTarget(self, action: #selector(self.dismissesView), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(self.initCamera), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(self.executeTag), for: .touchUpInside)
    }
    
    @objc func dismissesView(){
        print("dismiss view")
        //must do these do remove a subVC from parent
        self.view.removeFromSuperview()
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func initCamera(){
        print("camera tapped!!")

        let cameraVC = HelperFunctions().getTopMostViewController()
        let alert = Camera()
        alert.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            cameraVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func executeTag(){
        print("execute tag!!")
    }
}

extension CameraViewController: PassImageDelegate {
    func getImage(image: UIImage) {
        subtitle.text = "Go ahead, tag this trash."
        self.imageView.image = image
        self.cameraButton.isHidden = true
        submitButton.isEnabled = true
    }
    
    
    
}
