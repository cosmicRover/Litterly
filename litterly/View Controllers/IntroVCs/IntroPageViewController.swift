//
//  IntroViewController.swift
//  litterly
//
//  Created by Joy Paul on 4/5/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

//extends UIPageController and their delegates + data source
class IntroPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    //contains an array of VCs that we crated and have given them unique storyBoard IDs
    lazy var orderedVC: [UIViewController] = {
        return [self.newVc(viewController: "pageOne"),
                self.newVc(viewController: "pageTwo"),
                self.newVc(viewController: "pageThree")]
    }()
    
    //init our PageControl var
    var pageControl = UIPageControl()

    //set the delegate and data source to self, and then init the first VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        if let firstVc = orderedVC.first{
            setViewControllers([firstVc], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
    }
    
    //configures the dots for the pageControl (page indicator) as a custom view.
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 60, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedVC.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.pageControlUnselectedPageGreen
        pageControl.currentPageIndicatorTintColor = UIColor.mainGreen
        self.view.addSubview(pageControl)
    }
    
    //the animation func for pageControl. didFinishAnimating
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageCVC = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedVC.firstIndex(of: pageCVC)!
    }
    
    
    //viewControllerBefore holds the logic to display previous VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVC.firstIndex(of: viewController) else{
            return nil
        }
        
        let prevIndex = vcIndex - 1
        
        guard prevIndex >= 0 else{
            return orderedVC.last
        }
        
        guard orderedVC.count > prevIndex else{
            return nil
        }
        
        return orderedVC[prevIndex]
    }
    
    //holds logic to display the next VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVC.firstIndex(of: viewController) else{
            return nil
        }
        
        let nextIndex = vcIndex + 1
        
        guard orderedVC.count != nextIndex else{
            return orderedVC.first
        }
        
        guard orderedVC.count > nextIndex else{
            return nil
        }
        
        return orderedVC[nextIndex]
    }
    
    //returns a VC from the Main.storyboard by instantiating one with the VC's identifier
    func newVc(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    

}
