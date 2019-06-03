//
//  MapsViewController-Slide-In-Card.swift
//  litterly
//
//  Created by Joy Paul on 4/9/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import UIKit

extension MapsViewController{
    
    //sets up the card from the CardViewController.xib file and adds to our view's subview
    func addSlideInCardToMapView(){
        //init a visualEffectView and add it to our subview
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        //init the .xib file for the CardViewController, add as a child to our own view and add as a subview
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        //giving the card an x, y, with and height to follow
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        //making sure it clips to bounds
        cardViewController.view.clipsToBounds = true
        
        //modifying the corner radius upon loading
        //cardViewController.view.layer.cornerRadius = 12
        
        //init our pan and tap gestures with their respective objc funcs and then adding them to the CVC's handleArea view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapsViewController.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MapsViewController.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    //handles tap gesture by switching the state and calling animateTransitionIfNeeded
    @objc
    func handleCardTap(recognizer:UITapGestureRecognizer){
        switch recognizer.state{
        case.ended:
            //***VERY IMPORTANT*** use view.bringSubviewToFront(viewName) in order to juggle between which view is interactable
            //not sure why this seems to fix the problem of view conflicts between mapsView and card view... but I'm not
            //complaining -.-
            //view.bringSubviewToFront(cardViewController.view)
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    //handles pan gesture by cycling through the possible cases and calling the animation funcs
    @objc
    func handleCardPan(recognizer: UIPanGestureRecognizer){
        switch recognizer.state{
            
        case .possible:
            //it should always be possible?
            break
        case .began:
            //start transition
            startInteractiveTransition(state: nextState, duration: 0.5)
        case .changed:
            //update transition
            //translates the user's pan gesture into a fraction so that updateInteractiveTransition can use it to animate accordingly
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            
            updateInteractiveTransition(fractionCompleted: fractionComplete)
            
        case .ended:
            //continue transition till the transition itself ends
            continuesInteractiveTransition()
        case .cancelled:
            //once started can't be cancelled
            break
        case .failed:
            //
            break
        @unknown default:
            print("error on cardPanGes")
            fatalError()
        }
    }
    
    //the animation funcs that handles the animations based on the current state of the card
    
    func animateTransitionIfNeeded(state: CardState, duration:TimeInterval){
        //if no running animation, add a UIPropertyAnimator with duration and dampRation. We animate using the view's y axis since the
        //caerd only goes up or down
        if runningAnimations.isEmpty{
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                
                switch state{
                case . expanded:
                    //***VERY IMPORTANT*** use view.bringSubviewToFront(viewName) in order to have card slidein properly
                    //make sure to send the maps View to back to achieve the blur
                    //effect
                    self.view.bringSubviewToFront(self.cardViewController.view)
                    self.view.sendSubviewToBack(self.mapView!)
                    
                    //diabling the nav bar
                    //TODO add a blur effect to the nav bar
                    self.navigationController?.navigationBar.isUserInteractionEnabled = false
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    self.cardViewController.arrowImage.image = UIImage(named: "down_arrow")
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                    self.cardViewController.arrowImage.image = UIImage(named: "up_arrow")
                }
            }
            
            //Completion block for frame animation. After an animation is complete, remove all runningAnimations
            frameAnimator.addCompletion {_ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
                
                //once the card slide down animation is finished, bring
                //the mapview to front first and then bring the cardView to front
                //second
                if self.cardVisible == false{
                    self.view.bringSubviewToFront(self.mapView!)
                    self.view.bringSubviewToFront(self.cardViewController.view)
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                }
            }
            
            //start the animation and appened to the array
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            //animates the corner radius modification
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state{
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                    
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            //aniamtes a blur effect on the parent view itself
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state{
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    //call when you need to start an interactiveTransition
    func startInteractiveTransition(state: CardState, duration:TimeInterval){
        
        if runningAnimations.isEmpty{
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        //when animation is paused, the animation progress completed takes the value of animator's fraction completed
        for animator in runningAnimations{
            animator.pauseAnimation()
            animatorProgressWhenInterrupted = animator.fractionComplete
        }
        
    }
    
    //gets called when animation value has changed and needs a new fractionCompleted
    func  updateInteractiveTransition(fractionCompleted:CGFloat){
        for animator in runningAnimations{
            animator.fractionComplete = fractionCompleted + animatorProgressWhenInterrupted
        }
    }
    
    //gets called when interactive transition needs to be completed regardless
    func continuesInteractiveTransition(){
        for animator in runningAnimations{
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

