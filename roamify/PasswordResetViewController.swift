//
//  PasswordResetViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var object: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
        
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            // giriş yapma işlemi yap
            
            Auth.auth().signIn(withEmail: emailTextField.text! , password: passwordTextField.text!){
                (authdataresult, error) in
                if error != nil{
                    self.errorMessage(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata ALdınız, Lütfen Tekrar  Deneyiniz")
                }else{
                    self.performSegue(withIdentifier: "toHomePageVC2", sender: nil)
                }
            }
        }else {
            errorMessage(titleInput: "Hata!", messageInput: "Email Ve Parola Giriniz!")
        }
        
        
        
    }
    func errorMessage(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert
        )
        let okButton = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}
