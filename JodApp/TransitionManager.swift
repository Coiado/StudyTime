//
//  transitionManager.swift
//  JodApp
//
//  Created by Bruno Eiji Yoshida on 15/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//


import UIKit

class PanTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning {
    
    private var presenting = false
    private var interactive = false
    
    private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    private var statusBarBackground: UIView!
    
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action:"handleOnstagePan:")
            self.enterPanGesture.edges = UIRectEdge.Left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
            
            // create view to go behind statusbar
            self.statusBarBackground = UIView()
            self.statusBarBackground.frame = CGRect(x: 0, y: 0, width:
                self.sourceViewController.view.frame.width, height: 20)
            self.statusBarBackground.backgroundColor = self.sourceViewController.view.backgroundColor
            
            // add to window rather than view controller
//            UIApplication.sharedApplication().keyWindow!.addSubview(self.statusBarBackground)
        }
    }
    
    private var exitPanGesture: UIPanGestureRecognizer!
    
    var menuViewController: UIViewController! {
        didSet {
            self.exitPanGesture = UIPanGestureRecognizer()
            self.exitPanGesture.addTarget(self, action:"handleOffstagePan:")
            self.menuViewController.view.addGestureRecognizer(self.exitPanGesture)
        }
    }
    
    func handleOnstagePan(pan: UIPanGestureRecognizer){
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translationInView(pan.view!)
        
        // do some math to translate this to a percentage based value
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        // now lets deal with different states that the gesture recognizer sends
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            // set our interactive flag to true
            self.interactive = true
            
            // trigger the start of the transition
            self.sourceViewController.performSegueWithIdentifier("presentMenu", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            
            // update progress of the transition
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            if(d > 0.2){
                // threshold crossed: finish
                self.finishInteractiveTransition()
            }
            else {
                // threshold not met: cancel
                self.cancelInteractiveTransition()
            }
        }
    }
    
    // pretty much the same as 'handleOnstagePan' except
    // we're panning from right to left
    // perfoming our exitSegeue to start the transition
    func handleOffstagePan(pan: UIPanGestureRecognizer){
        
        let translation = pan.translationInView(pan.view!)
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * -0.5
        
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.menuViewController.performSegueWithIdentifier("dismissMenu", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            self.interactive = false
            if(d > 0.2){
                self.finishInteractiveTransition()
            }
            else {
                self.cancelInteractiveTransition()
            }
        }
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // if our interactive flag is true, return the transition manager object
        // otherwise return nil
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as! MenuViewController : screens.to as! MenuViewController
        let topViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let topView = topViewController.view
        
        //        // prepare menu items to slide in
        //        if (self.presenting){
        //            //self.offStageMenuControllerInteractive(menuViewController) // offstage for interactive
        //        }
        
        // add the both views to our view controller
        
        container.addSubview(menuView)
        container.addSubview(topView)
        container.addSubview(self.statusBarBackground)
        
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            if (self.presenting){
                topView.transform = self.offStage(100)
            }
            else {
                topView.transform = CGAffineTransformIdentity
            }
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                if(transitionContext.transitionWasCancelled()){
                    
                    transitionContext.completeTransition(false)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.from.view)
                    
                }
                else {
                    
                    transitionContext.completeTransition(true)
                    // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                    UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                    
                }
                UIApplication.sharedApplication().keyWindow!.addSubview(self.statusBarBackground)
                
        })
        
    }
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    
}


class ButtonTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var presenting: Bool = false
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        
        let screens: (from: UIViewController, to: UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        let optionsViewController = !self.presenting ? screens.from as! OptionsViewController : screens.to
         as! OptionsViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        
        let optionsView = optionsViewController.view
        let bottomView = bottomViewController.view
        
        if self.presenting {
            self.offStage(optionsViewController)
        }
        
        
        containerView.addSubview(bottomView)
        containerView.addSubview(optionsView)
        
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.2, options: nil, animations: {
            
            if self.presenting{
                self.onStage(optionsViewController)
            }
            else
            {
                self.offStage (optionsViewController)
            }
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
                
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
        
        })
        
    }
    
    func setupStage(amount: CGFloat) -> CGAffineTransform{
        return CGAffineTransformMakeTranslation(0, amount)
    }
    
    
    func offStage (optionViewController: OptionsViewController){
        
        optionViewController.view.alpha = 0
        
        let firstRow = 600 as CGFloat
        let secondRow = 550 as CGFloat
        let thirdRow = 500 as CGFloat
        let fourthRow = 450 as CGFloat
        let fifthRow = 400 as CGFloat
        
        
        optionViewController.teste1.transform = self.setupStage(-firstRow)
        optionViewController.teste2.transform = self.setupStage(-secondRow)
        optionViewController.teste3.transform = self.setupStage(-thirdRow)
        optionViewController.teste4.transform = self.setupStage(-fourthRow)
        optionViewController.teste5.transform = self.setupStage(-fifthRow)
        
        optionViewController.teste6.transform = self.setupStage(firstRow)
        optionViewController.teste7.transform = self.setupStage(secondRow)
        optionViewController.teste8.transform = self.setupStage(thirdRow)
        optionViewController.teste9.transform = self.setupStage(fourthRow)
        optionViewController.teste10.transform = self.setupStage(fifthRow)

        
        
    }
    
    func onStage (optionViewController : OptionsViewController){
        
        optionViewController.view.alpha = 1
        
        optionViewController.teste1.transform = CGAffineTransformIdentity
        optionViewController.teste2.transform = CGAffineTransformIdentity
        optionViewController.teste3.transform = CGAffineTransformIdentity
        optionViewController.teste4.transform = CGAffineTransformIdentity
        optionViewController.teste5.transform = CGAffineTransformIdentity
        optionViewController.teste6.transform = CGAffineTransformIdentity
        optionViewController.teste7.transform = CGAffineTransformIdentity
        optionViewController.teste8.transform = CGAffineTransformIdentity
        optionViewController.teste9.transform = CGAffineTransformIdentity
        optionViewController.teste10.transform = CGAffineTransformIdentity
    }
    
}










