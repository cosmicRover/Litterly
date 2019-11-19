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
    let cameraView: CameraView
    
    init(height:Double, width:Double){
        self.height = height
        self.width = width
        self.cameraView = CameraView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout(){
        view.addSubview(cameraView)
    }


}
