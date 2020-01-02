//
//  IntroVC.swift
//  Litterly
//
//  Created by Joy Paul on 12/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IntroVC: UIViewController {
    
    //MARK: init lazy loading UI properties
    private var backgroundImage: UIImageView = {
        let bImage = UIImageView()
        bImage.image = UIImage(named: "blue.png")
        bImage.translatesAutoresizingMaskIntoConstraints = false
        return bImage
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var featureImage: UIImageView = {
       let iView = UIImageView()
        iView.contentMode = .scaleAspectFit
        iView.image = UIImage(named: "")
        iView.translatesAutoresizingMaskIntoConstraints = false
        return iView
    }()
    
    //MARK: view models and other logic inits fo here
    private var viewModel:IntroVM = IntroVM()
    private var disposeBage = DisposeBag()
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintUI()
        setUpDataStream()
    }
    
    private func setUpDataStream(){
        let _ = viewModel.valueStream.observeOn(MainScheduler.instance)
            .subscribe{event in
                switch event{
                case .next(let data):
                    self.bindDataToUI(data: data)
                case .error(let error):
                    print(error)
                case .completed:
                    print("completed")
                }
        }
    }
    
    private func bindDataToUI(data: IntroPageDataModel){
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.subtitle
        self.featureImage.image = data.graphic
    }
    
    private func paintUI(){
        view.backgroundColor = UIColor.litterlyWhite
        view.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180.3)
        ])
        
        backgroundImage.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 70),
            titleLabel.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: 40)
        ])
        
        backgroundImage.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subTitleLabel.leftAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: 40)
        ])
        
        backgroundImage.addSubview(featureImage)
        NSLayoutConstraint.activate([
            featureImage.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            featureImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    
}
