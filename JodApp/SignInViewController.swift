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

    
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var tutorLabel: UILabel!
    @IBOutlet weak var signupLabel: UILabel!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!    
    @IBOutlet weak var tutorButton: UIButton!
    @IBOutlet weak var studentButton: UIButton!
    
    var tutor:Bool?
    
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
        let signupString = NSLocalizedString("Sign in", comment: "label de cadastro")
        let tutorString = NSLocalizedString("Tutor", comment: "Label para tutor")
        let studentString = NSLocalizedString("Student", comment: "Label para selecionar aluno")
        
        tutorLabel.text = tutorString
        studentLabel.text = studentString
        signupLabel.text = signupString
    }
    
    
    func setTextField()
    {
        let loginTextFieldString = NSLocalizedString("Username", comment: "text field de usuario")
        let passwordTextFieldString = NSLocalizedString("Password", comment: "text fiedl da senha")
        let confirmationTextFieldString = NSLocalizedString("Confirm password", comment: "text field da confirmacao da senah")
        let emailTextFieldString = NSLocalizedString("E-mail", comment: "text field do email")
        
        loginTextField.placeholder = loginTextFieldString
        passwordTextField.placeholder = passwordTextFieldString
        confirmationTextField.placeholder = confirmationTextFieldString
        emailTextField.placeholder = emailTextFieldString
    }

    func setButton()
    {
        let signupButtonString = NSLocalizedString("Sign in", comment: "Botao de cadastro")
        
        signupButton.setTitle(signupButtonString, forState: .Normal)
    }
    
    
    @IBAction func tutorAction(sender: AnyObject) {
        
        let checked = UIImage(named: "checked_checkbox.png")
        let unchecked = UIImage(named: "unchecked_checkbox.png")
        
        let image = tutorButton.imageForState(.Normal)
        
        if( image == checked){
            
            tutorButton.setImage(unchecked, forState: .Normal)
            
        }
        else{
            
            tutorButton.setImage(checked, forState: .Normal)
            studentButton.setImage(unchecked, forState: .Normal)
            self.tutor = true
        }
  
    }
    
    
    @IBAction func studentAction(sender: AnyObject) {
        
        let checked = UIImage(named: "checked_checkbox.png")
        let unchecked = UIImage(named: "unchecked_checkbox.png")
        
        let image = studentButton.imageForState(.Normal)
        
        if( image == checked){
            
            studentButton.setImage(unchecked, forState: .Normal)
            
        }
        else{
            
            studentButton.setImage(checked, forState: .Normal)
            tutorButton.setImage(unchecked, forState: .Normal)
            self.tutor = false
        }

        
    }
    
    
    @IBAction func signupAction(sender: AnyObject) {
        
        var username = loginTextField.text
        var password = passwordTextField.text
        var confirmation = confirmationTextField.text
        var email = emailTextField.text
        let errorString = NSLocalizedString("Error", comment: "titulo do error")
            
        actInd.startAnimating()
        
        if (tutor == nil){
            
            let tutorString = NSLocalizedString("Choose tutor or student",comment: "erro de quando nao for escolhido nem tutor nem student")
            
            var alert = UIAlertView(title: errorString, message: tutorString, delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
            
        }
        
        else if (password != confirmation)
        {
            let passwordErrorString = NSLocalizedString("Password does not match", comment: "erro de quando a senha nao é a mesma")
            
            var alert = UIAlertView(title: errorString, message: passwordErrorString, delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
        
        else if(count(username) < 6 || count(password) < 6 )
        {
            let usernameErrorString = NSLocalizedString("Username and password must be at least 6 caracter", comment: "mensagem de erro")
            
            var alert = UIAlertView(title: errorString , message: usernameErrorString, delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
            
        else if(count(email) < 1)
        {
            let emailErrorString = NSLocalizedString("Please enter a valid e-mail", comment: "error de email")
            
            var alert = UIAlertView(title: errorString, message: emailErrorString, delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            actInd.stopAnimating()
        }
        
        else {
            var newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            newUser["tutor"] = self.tutor
            
            newUser.signUpInBackgroundWithBlock({ (sucess, error) -> Void in
                
                if(sucess)
                {
//                    var alert = UIAlertView(title: "Criado com sucesso", message: "Conta criada com sucesso", delegate: self, cancelButtonTitle: "Ok")
//                    alert.show()
                    if let tutor = PFUser.currentUser()?.objectForKey("tutor") as? Bool{
                        
                        if(tutor == false){
                            println("aluno")
                            self.performSegueWithIdentifier("aluno", sender: self)
                        }
                        else{
                            println("tutor")
                            self.performSegueWithIdentifier("tutor", sender: self)
                        }
                        
                    }
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







