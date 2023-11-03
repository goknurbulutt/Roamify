//
//  SignUpViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var object: UIImageView!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordAgainTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    

    @IBAction func doneClicked(_ sender: Any) {
        performSegue(withIdentifier:"toHomePageVC", sender: nil)
        
    }
    
    
    
    
    
    
}
