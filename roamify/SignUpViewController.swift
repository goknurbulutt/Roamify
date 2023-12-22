//
//  SignUpViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var object: UIImageView!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    // Firestore referansını oluştur
        let db = Firestore.firestore()

        override func viewDidLoad() {
            super.viewDidLoad()
        }


    @IBAction func doneClicked(_ sender: Any) {
        
       
            // Ad ve soyad boş olmamalıdır
            guard let name = nameTextField.text, !name.isEmpty,
                  let surname = surnameTextField.text, !surname.isEmpty else {
                errorMessage(titleInput: "Hata!", messageInput: "Ad ve soyad boş olmamalıdır!")
                return
            }
            
            // E-posta ve şifre boş olmamalıdır
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                errorMessage(titleInput: "Hata!", messageInput: "E-posta ve şifre boş olmamalıdır!")
                return
            }
            
            // Şifreler eşleşmeli
            guard password == passwordAgainTextField.text else {
                errorMessage(titleInput: "Hata!", messageInput: "Şifreler eşleşmiyor!")
                return
            }

            // Firebase kullanıcı oluşturma
            Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
                if let error = error {
                    self.errorMessage(titleInput: "Hata", messageInput: error.localizedDescription)
                } else {
                    
                    let user = Auth.auth().currentUser
                    let changeRequest = user?.createProfileChangeRequest()
                    changeRequest?.displayName = "\(name) \(surname)"
                    changeRequest?.commitChanges(completion: { (error) in
                        if let error = error {
                            print("Hata: \(error.localizedDescription)")
                        } else {
                            // Başarıyla kaydedildi, giriş sayfasına yönlendir
                            
                            self.performSegue(withIdentifier: "toHomePageVC", sender: nil)
                        }
                    })
                }
            }
        


        
        
    }
    
    func addAdditionalUserData(name: String, surname: String) {
        if let currentUser = Auth.auth().currentUser {
            let userData: [String: Any] = [
                "name": name,
                "surname": surname,
                // Diğer ek bilgileri buraya ekleyebilirsiniz
            ]

            // Firestore'da "users" koleksiyonuna kullanıcı bilgilerini ekle
            db.collection("users").document(currentUser.uid).setData(userData) { error in
                if let error = error {
                    print("Error adding user data to Firestore: \(error.localizedDescription)")
                } else {
                    print("User data added to Firestore successfully!")
                }
            }
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
    
    
    
    
    
    

