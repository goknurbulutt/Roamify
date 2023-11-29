//
//  AddRouteViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class AddRouteViewController: UIViewController {
    
    @IBOutlet weak var object: UIImageView!
    
    @IBOutlet weak var howDoesLabel: UITextView!
    
    @IBOutlet weak var routeNameTextField: UITextField!
    let db = Firestore.firestore()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doneClicked(_ sender: UIButton) {
        if let routeName = routeNameTextField.text {
            // Firebase'e rota ekleyebilirsin
            db.collection("routes").addDocument(data: ["routeName": routeName]) { error in
                if let error = error {
                    print("Error adding route: \(error.localizedDescription)")
                } else {
                    print("Route added successfully!")
                    self.performSegue(withIdentifier: "toCreatedStepsVC", sender: self)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreatedStepsVC" {
            if let createdStepsVC = segue.destination as? CreatedStepsViewController {
                createdStepsVC.routeName = routeNameTextField.text
            }
        }
    }
    }
