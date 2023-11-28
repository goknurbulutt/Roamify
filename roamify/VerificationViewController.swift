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
            errorMessage(titleInput: "Hata!", messageInput: "E-posta boş olmamalıdır!")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset link: \(error.localizedDescription)")
            } else {
                print("Password reset link sent successfully")
                if self.emailTextField.text != ""{
                    
                    
                    self.performSegue(withIdentifier: "toPRV", sender: nil)}
            }
            
            
        }
    }
    
    
    func errorMessage(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert
        )
        let okButton = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(okButton)
        
        
                                      
        
        
    }
    
}




