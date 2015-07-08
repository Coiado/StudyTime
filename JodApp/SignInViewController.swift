//
//  SignInViewController.swift
//  JodApp
//
//  Created by Bruno Eiji Yoshida on 08/07/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    
    @IBOutlet weak var signupLabel: UILabel!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150)) as UIActivityIndicatorView

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
    }
    
    
    func setLabel()
    {
        signupLabel.text = "Cadastre-se"
    }
    
    
    func setTextField()
    {
        loginTextField.placeholder = "Usuário"
        passwordTextField.placeholder = "Senha"
        confirmationTextField.placeholder = "Confirme a senha"
        emailTextField.placeholder = "E-mail"
    }

    func setButton()
    {
        signupButton.setTitle("Cadastrar", forState: .Normal)
    }
    
    
    @IBAction func signupAction(sender: AnyObject) {
        
        var username = loginTextField.text
        var password = passwordTextField.text
        var confirmation = confirmationTextField.text
        var email = emailTextField.text
       
        actInd.startAnimating()
        
        if (password != confirmation)
        {
            var alert = UIAlertView(title: "Error", message: "A senha não é a mesma", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
        
        else if(count(username) < 6 || count(password) < 6 )
        {
            var alert = UIAlertView(title: "Error", message: "Usuário e senha devem ter pelo menos 6 caracteres", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
            
        else if(count(email) < 1)
        {
            var alert = UIAlertView(title: "Error", message: "Por favor entre com um e-mail", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
        
        else {
            
            var newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            
            newUser.signUpInBackgroundWithBlock({ (sucess, error) -> Void in
                
                if(sucess)
                {
                    var alert = UIAlertView(title: "Criado com sucesso", message: "Conta criada com sucesso", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                }
                else
                {
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "Ok")
                }
                
            })
        }
    }
    
    
    
}







