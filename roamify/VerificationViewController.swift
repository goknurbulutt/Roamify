//
//  VerificationViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import FirebaseAuth

class VerificationViewController: UIViewController {
   
   @IBOutlet weak var object: UIImageView!
   
   @IBOutlet weak var emailTextField: UITextField!
   
   override func viewDidLoad() {
       super.viewDidLoad()
   }
   
   @IBAction func sendLinkClicked(_ sender: Any) {
       guard let email = emailTextField.text, !email.isEmpty else {
           return
       }
       
       Auth.auth().sendPasswordReset(withEmail: email) { error in
           if let error = error {
               print("Şifre sıfırlama bağlantısı gönderilirken hata oluştu: \(error.localizedDescription)")
           } else {
               print("Şifre sıfırlama bağlantısı başarıyla gönderildi")
           }
       }
   }
}

