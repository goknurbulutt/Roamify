//
//  ViewController.swift
//  roamify
//
//  Created by Göknur Bulut on 19.10.2023.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var object: UIImageView!
    
    @IBOutlet weak var labelGo: UILabel!
    
    @IBOutlet weak var labelMotivation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
    }

   
    @IBAction func signUpButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
        
        
    }
    
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toPasswordResetVC", sender: nil)
    }
    
    @IBAction func helpButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toHelpVC", sender: nil)
    }
}


