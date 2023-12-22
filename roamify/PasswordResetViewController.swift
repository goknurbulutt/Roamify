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
                
                // E-postanın Firebase'de kayıtlı olup olmadığını kontrol et
                Auth.auth().signIn(withEmail: emailTextField.text!, password: self.passwordTextField.text!) { (authDataResult, signInError) in
                    if let signInError = signInError {
                        // Giriş yapma işlemi sırasında bir hata oluştu
                        self.showErrorAlert(title: "Hata!", message: signInError.localizedDescription)
                    } else {
                        // Giriş başarılı, kullanıcıyı yönlendir
                        if let user = authDataResult?.user {
                            // Kullanıcı ID'sini consola yazdır
                            print("Kullanıcı ID:", user.uid)
                        }
                        self.performSegue(withIdentifier: "toHomePageVC2", sender: nil)
                    }
                }
            } else {
                errorMessage(titleInput: "Hata!", messageInput: "E-posta ve parola giriniz.")
            }
        }

            func showErrorAlert(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)

                // Bu view controller'dan alert'ı göster
                self.present(alert, animated: true, completion: nil)
            }

            func errorMessage(titleInput: String, messageInput: String){
                let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default , handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
