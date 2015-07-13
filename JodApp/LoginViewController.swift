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
        let loginString = NSLocalizedString("Entrar", comment: "label superior login")
        let cadastroString = NSLocalizedString("Não é cadastrado?", comment: "label para mostrar o cadastro")
        
        loginLabel.text = loginString
        cadastroLabel.text = cadastroString
    }
    
    func setButton()
    {
        let loginButtonString = NSLocalizedString("Entrar", comment: "botao de login")
        let signinButtonString = NSLocalizedString("Cadastre-se", comment: "botao de cadastro")
        
        loginButton.setTitle(loginButtonString, forState: .Normal)
        signInButton.setTitle(signinButtonString, forState: .Normal)
    }
    
    
    func setTextField()
    {
        let loginTextString  = NSLocalizedString("Usuário", comment: "text field de usuario")
        let passwordTextString  = NSLocalizedString("Senha", comment: "text field de senha")
        
        loginTextField.placeholder = loginTextString
        passwordTextField.placeholder = passwordTextString
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        var username: String = loginTextField.text
        var password: String = passwordTextField.text
        
        self.actInd.startAnimating()
        
        if (count(username) < 6 || count(password) < 6)
        {
            
            let loginTitleString = NSLocalizedString("Login falhou", comment: "titulo da mensagem de erro")
            let loginMessageString = NSLocalizedString("Usuário e senha devem ter mais de 6", comment: "mensagem de erro ")
            
            var alert = UIAlertView(title: loginTitleString, message: loginMessageString, delegate: self, cancelButtonTitle: "Ok")
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
                
                let errorString = NSLocalizedString("Erro", comment: "titulo da mensagem de erro")
                
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






