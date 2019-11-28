//
//  Camera.swift
//  Litterly
//
//  Created by Joy Paul on 11/27/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import AVFoundation

protocol PassImageDelegate {
    func getImage(image: UIImage)
}


class Camera: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var delegate: PassImageDelegate!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    
    lazy var camerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounds = UIScreen.main.bounds
        return view
    }()
    
    lazy var captureButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Capture", for: .normal)
        button.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(camerView)
//        setupLayout()
    }
    
    @objc func didTakePhoto(){
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        let image = UIImage(data: imageData)
        print("photo taken")
        //send the image back to slide in card
        
        delegate?.getImage(image: image!)
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func setupCaptureButton(){
        view.addSubview(captureButton)
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else{
            print("unable to access camera")
            return
        }

        do{
            let input = try AVCaptureDeviceInput(device: backCamera)

            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput){
                print("capture session!!!")
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }

        } catch let error{
            print("unable to init back camera \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview(){
        print("preview is happening?")
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.view.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.camerView.bounds
        }
        
        setupCaptureButton()
    }

}
