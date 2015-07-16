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

class logInViewController: UIViewController, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate
{
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var cadastroLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tutor = PFUser.currentUser()?.objectForKey("tutor") as? Bool{
            
            if(tutor == false){
                println("Aluno no ViewWillAppear")
                self.performSegueWithIdentifier("aluno", sender: self)
            }
            else{
                println("Tutor no ViewWillAppear")
                self.performSegueWithIdentifier("tutor", sender: self)
            }
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       PFUser.logOut()
        
        println(PFUser.currentUser())
        
        
        if let tutor = PFUser.currentUser()?.objectForKey("tutor") as? Bool{
            
            if(tutor == false){
                println("Aluno no ViewDidLoad")
                performSegueWithIdentifier("aluno", sender: self)
            }
            else{
                println("Tutor no ViewDidLoad")
                performSegueWithIdentifier("tutor", sender: self)
            }
            
        }
        
        
        setLabel()
        setTextField()
        setButton()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
    }
    
    func setLabel()
    {
        let loginString = NSLocalizedString("Login", comment: "label superior login")
        let cadastroString = NSLocalizedString("New user?", comment: "label para mostrar o cadastro")
        
        loginLabel.text = loginString
        cadastroLabel.text = cadastroString
    }
    
    func setButton()
    {
        let loginButtonString = NSLocalizedString("Login", comment: "botao de login")
        let signinButtonString = NSLocalizedString("Sign in", comment: "botao de cadastro")
        
        loginButton.setTitle(loginButtonString, forState: .Normal)
        signInButton.setTitle(signinButtonString, forState: .Normal)
    }
    
    
    func setTextField()
    {
        let loginTextString  = NSLocalizedString("Username", comment: "text field de usuario")
        let passwordTextString  = NSLocalizedString("Password", comment: "text field de senha")
        
        loginTextField.placeholder = loginTextString
        passwordTextField.placeholder = passwordTextString
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        var username: String = loginTextField.text
        var password: String = passwordTextField.text
        
        self.actInd.startAnimating()
        
        if (count(username) < 6 || count(password) < 6)
        {
            
            let loginTitleString = NSLocalizedString("Login failed", comment: "titulo da mensagem de erro")
            let loginMessageString = NSLocalizedString("Username and password must be at least 6 caracters", comment: "mensagem de erro ")
            
            var alert = UIAlertView(title: loginTitleString, message: loginMessageString, delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            self.actInd.stopAnimating()
        }
        else
        {
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
            
            self.actInd.stopAnimating()
            
            if ((user) != nil) {
                                
                if let tutor = PFUser.currentUser()?.objectForKey("tutor") as? Bool{
                    
                    if(tutor == false){
                        println("Logou aluno")
                        self.performSegueWithIdentifier("aluno", sender: self)
                    }
                    else{
                        println("Logou tutor")
                        self.performSegueWithIdentifier("tutor", sender: self)
                    }
                    
                }

                
            }else {
                
                let errorString = NSLocalizedString("Error", comment: "titulo da mensagem de erro")
                
                var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }
            
        })
        
        }
        
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("signup", sender: self)
        
        
    }
    
    
    
}






