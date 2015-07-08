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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        loginLabel.text = "Entrar"
        cadastroLabel.text = "Não é cadastrado?"
    }
    
    func setButton()
    {
        loginButton.setTitle("Entrar", forState: .Normal)
        signInButton.setTitle("Cadastre-se", forState: .Normal)
    }
    
    
    func setTextField()
    {
        loginTextField.placeholder = "Usuário"
        passwordTextField.placeholder = "Senha"
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        var username: String = loginTextField.text
        var password: String = passwordTextField.text
        
        self.actInd.startAnimating()
        
        if (count(username) < 6 || count(password) < 6)
        {
            var alert = UIAlertView(title: "Login falhou", message: "Usuário e senha devem ter mais de 6", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            self.actInd.stopAnimating()
        }
        else
        {
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
            
            self.actInd.stopAnimating()
            
            if ((user) != nil) {
                
                var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }else {
                
                var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }
            
        })
        
        }
        
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        
        performSegueWithIdentifier("signup", sender: self)
        
        
    }
    
    
    
}






