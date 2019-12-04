//
//  CameraView.swift
//  Litterly
//
//  Created by Joy Paul on 11/14/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Geofirestore
import CoreLocation

class CameraViewController: UIViewController {
    
//    var delegate: PassImageDelegate
    
    let height:Double
    let width:Double
    let trashType:String
    let timezone:String
    
    let cameraIcon = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
    let backIcon = UIImage(named: "white_back_arrow")?.withRenderingMode(.alwaysOriginal)
    var imagePicker: UIImagePickerController!
    let db = GlobalValues.db
    var geoFirestore:GeoFirestore!
    let helper = HelperFunctions()
    let firestoreCollection = Firestore.firestore().collection("TaggedTrash")
    
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
    
    
    init(height:Double, width:Double, trashType:String, timezone:String){
        self.height = height
        self.width = width
        self.trashType = trashType
        self.timezone = timezone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.isUserInteractionEnabled = true
        geoFirestore = GeoFirestore(collectionRef: firestoreCollection)
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
        executeTagTrash { (result) in
            if let _ = result{
                //need main thread to work with UI elements 
                self.postNotificationAndDismssView()
            }else{
                //something went wrong, but still post notification
                self.postNotificationAndDismssView()
            }
        }
    }
    
    func postNotificationAndDismssView(){
        DispatchQueue.main.async {
            self.dismissesView()
            NotificationCenter.default.post(name: NSNotification.Name("reportTapped"), object: nil)
        }
    }
}

extension CameraViewController: PassImageDelegate {
    func getImage(image: UIImage) {
        subtitle.text = "Go ahead, tag this trash."
        savePhotoToTemp(image: image)
        self.imageView.image = image
        self.cameraButton.isHidden = true
        submitButton.isEnabled = true
    }
    
    func savePhotoToTemp(image: UIImage){
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "trash"
        let fileUrl = dir.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 1.0){
            
            if !FileManager.default.fileExists(atPath: fileUrl.path){
                do {
                    try data.write(to: fileUrl)
                    print("file saved")
                } catch{
                    print("error saving file")
                }
            }else{
                do {
                    try FileManager.default.removeItem(at: fileUrl)
                    try data.write(to: fileUrl)
                    print("file saved")
                } catch{
                    print("error saving file")
                }
            }
        }
    }
    
    func loadImage() -> URL{
        let fileName = "trash"
        let dir = FileManager.SearchPathDirectory.documentDirectory
        let DM = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(dir, DM, true)
        if let dirPath = paths.first{
            let url = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            print("url retrieved")
            return url
        }
        return URL(string: "could_not_get_url")!
    }
    
}


extension CameraViewController{
    
    func uploadImage(imageName:String){
        let imageName = imageName
        let imageUrl = loadImage()
        let imageRef = Storage.storage().reference().child("TrashPics/\(imageName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = imageRef.putFile(from: imageUrl, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else{
                return //error
            }
            print("upload complete")
            print(metadata.bucket)
        }
    }
    
    func executeTagTrash(completionHandler: @escaping (String?) -> Void){
        //checking to see if location services is enabled, then proceeding to report the trash
        let mapFuncs = MapsViewController()
        mapFuncs.checkLocationServices()
        
        if let coordinates = mapFuncs.locationManager.location?.coordinate{
            print(coordinates.latitude)
            print(coordinates.longitude)
            
            guard let firebaseUserInstance = Auth.auth().currentUser else {return}
            let id = "\(coordinates.latitude)" + "\(coordinates.longitude)"+"marker" as String
            let author = firebaseUserInstance.email!
            
            let docRef = db.collection("TaggedTrash").document("\(id)")
            
            docRef.getDocument { (document, error) in
                if let document = document {
                    
                    
                    if document.exists{
                        //show alert saying marker already exists
                        print("data already exists")
                        self.helper.showErrorAlert()
                        
                    } else {
                        
                        print("Document does not exist and we are free to create one")
                        //gets tag address and the neighborhood from reverseGeocode
                        mapFuncs.reverseGeocodeApi(on: coordinates.latitude, and: coordinates.longitude) { (address, userCurrentNeighborhood, error) in
                        
                        print(address!)
                        print(userCurrentNeighborhood!)
                            let trashTag = TrashDataModel(id: id, author: author, lat: coordinates.latitude, lon: coordinates.longitude, trash_type: self.trashType, timezone: self.timezone, street_address: address!, is_meetup_scheduled: false, expiration_date: 0.0)
                        
                            self.submitTrashToFirestore(with: trashTag.dictionary, for: id)
                            self.setLocationWithGeoFirestore(for: id, on: coordinates)
                            let id = "\(coordinates.latitude)" + "\(coordinates.longitude)"+"photo" as String
                            self.uploadImage(imageName: id)
                            completionHandler("pass")
                        }
                    }
                }}
        } else{
            //show an alert saying that location is off
            // can get detailed direction on how to do that
            print("an error occoured tagging trash!")
            completionHandler("fail")
        }
    }
    
    //adds document to firestore
    func submitTrashToFirestore(with dictionary: [String:Any], for id:String){
        
        db.collection("TaggedTrash").document("\(id)").setData(dictionary) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
            
        }
        
    }
    
    //updates neighborhood on each tag
    func updateUserCurrentNeighborhood(forUser id:String, with neighborhood:String){
        db.collection("Users").document("\(id)").updateData([
            "neighborhood" : neighborhood
        ]) { (error:Error?) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //**************EXPERIMENTS*****************
    func setLocationWithGeoFirestore(for id:String, on location:CLLocationCoordinate2D){
        
        let cllocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geoFirestore.setLocation(location: cllocation, forDocumentWithID: "\(id)") { (error) in
            if let error = error {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
    }
    
}
