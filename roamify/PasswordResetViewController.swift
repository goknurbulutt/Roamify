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
        performSegue(withIdentifier: "toVerificationVC", sender: nil)
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
        
        
        if emailTextField.text != "" && passwordTextField.text != "" {
                let email = emailTextField.text!
                
                // E-postanın Firebase'de kayıtlı olup olmadığını kontrol et
                Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
                    if let error = error {
                        // E-posta kontrolünde bir hata oluştu
                        self.errorMessage(titleInput: "Hata!", messageInput: error.localizedDescription)
                    } else if methods == nil || methods!.isEmpty {
                        // Herhangi bir giriş yöntemi bulunamadı, yani kullanıcı mevcut değil
                        self.errorMessage(titleInput: "Hata!", messageInput: "Bu e-posta ile kayıtlı bir kullanıcı bulunamadı. Lütfen kayıt olun.")
                    } else {
                        // Kullanıcı mevcut, giriş yapma işlemine devam et
                        Auth.auth().signIn(withEmail: email, password: self.passwordTextField.text!) { (authDataResult, signInError) in
                            if let signInError = signInError {
                                // Giriş yapma işlemi sırasında bir hata oluştu
                                self.errorMessage(titleInput: "Hata!", messageInput: signInError.localizedDescription)
                            } else {
                                // Giriş başarılı
                                self.performSegue(withIdentifier: "toHomePageVC2", sender: nil)
                            }
                        }
                    }
                }
            } else {
                errorMessage(titleInput: "Hata!", messageInput: "E-posta ve parola giriniz.")
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
