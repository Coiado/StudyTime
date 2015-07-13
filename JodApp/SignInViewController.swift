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
        let signupString = NSLocalizedString("Cadastre-se", comment: "label de cadastro")
        
        signupLabel.text = signupString
    }
    
    
    func setTextField()
    {
        let loginTextFieldString = NSLocalizedString("Usuário", comment: "text field de usuario")
        let passwordTextFieldString = NSLocalizedString("Senha", comment: "text fiedl da senha")
        let confirmationTextFieldString = NSLocalizedString("Confirme a senha", comment: "text field da confirmacao da senah")
        let emailTextFieldString = NSLocalizedString("E-mail", comment: "text field do email")
        
        loginTextField.placeholder = loginTextFieldString
        passwordTextField.placeholder = passwordTextFieldString
        confirmationTextField.placeholder = confirmationTextFieldString
        emailTextField.placeholder = emailTextFieldString
    }

    func setButton()
    {
        let signupButtonString = NSLocalizedString("Cadastrar", comment: "Botao de cadastro")
        
        signupButton.setTitle(signupButtonString, forState: .Normal)
    }
    
    
    @IBAction func signupAction(sender: AnyObject) {
        
        var username = loginTextField.text
        var password = passwordTextField.text
        var confirmation = confirmationTextField.text
        var email = emailTextField.text
        let errorString = NSLocalizedString("Erro", comment: "titulo do error")
        println("asa")
        
        actInd.startAnimating()
        
        if (password != confirmation)
        {
            let passwordErrorString = NSLocalizedString("A senha não é a mesma", comment: "erro de quando a senha nao é a mesma")
            
            var alert = UIAlertView(title: errorString, message: passwordErrorString, delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
        
        else if(count(username) < 6 || count(password) < 6 )
        {
            let usernameErrorString = NSLocalizedString("Usuário e senha devem ter pelo menos 6 caracteres", comment: "mensagem de erro")
            
            var alert = UIAlertView(title: errorString , message: usernameErrorString, delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
            
        else if(count(email) < 1)
        {
            let emailErrorString = NSLocalizedString("Por favor entre com um e-mail", comment: "error de email")
            
            var alert = UIAlertView(title: errorString, message: emailErrorString, delegate: self, cancelButtonTitle: "Ok")
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
                    
                    var alert = UIAlertView(title: errorString, message: "\(error)", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                }
                
            })
            actInd.stopAnimating()
        }
    }
    
    
    
}







