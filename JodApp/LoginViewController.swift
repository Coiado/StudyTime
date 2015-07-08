//
//  logInViewController.swift
//  JodiApp
//
//  Created by Bruno Eiji Yoshida on 06/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class logInViewController: UIViewController, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate {
    
    var logInViewController: PFLogInViewController = PFLogInViewController()
    var signInViewController: PFSignUpViewController = PFSignUpViewController()
    
    override func viewDidLoad() {
        [super.viewDidLoad()]
    }
    
    override func viewDidAppear(animated: Bool) {
        [super.viewDidAppear(animated)]
        if(PFUser.currentUser() == nil){
            
            self.logInViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten
            
            var logoTitle = UILabel()
            logoTitle.text = "JodiApp"
            
            self.logInViewController.logInView!.logo = logoTitle
            
            
            self.logInViewController.delegate = self
            
            
            self.signInViewController.signUpView!.logo = logoTitle
            
            self.signInViewController.delegate = self
            
            self.presentViewController(self.logInViewController, animated: false, completion: nil)
        }
        
    }
    
    
    
    
    // MARK: Parse log in
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }else {
            var alert = UIAlertView(title: "Invalid", message: "Username and password must be complete", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        performSegueWithIdentifier("student", sender: self)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?)
    {
        
        var alert = UIAlertView(title: "Invalid", message: "Fail to log in", delegate: self, cancelButtonTitle: "OK")
        alert.show()
        
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
    
    
    
    // MARK : Parse Sign in
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        var alert = UIAlertView(title: "Sucessful", message: "Your account was sucessful create", delegate: self, cancelButtonTitle: "OK")
        alert.show()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        println("FAiled to sign up...")
        
    }
    
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        println("User dismissed sign up.")
        
    }
    
}

