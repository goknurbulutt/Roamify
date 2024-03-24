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
    
    let userId = Auth.auth().currentUser?.uid
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  

    @IBAction func doneClicked(_ sender: UIButton) {
        
        guard let routeName = routeNameTextField.text, !routeName.isEmpty else {
                    showAlert(message: "Please enter a route name.")
                    return
                }
                
                // Firestore'e rota eklemek
                let userID = Auth.auth().currentUser?.uid// Örnek kullanıcı kimliği, kullanıcı oturum açtıktan sonra gerçek kullanıcı kimliğini almalısınız
        let userRoutesCollection = db.collection("users").document(userId!).collection("routes")
                
                userRoutesCollection.addDocument(data: ["routeName": routeName]) { error in
                    if let error = error {
                        print("Error adding route: \(error.localizedDescription)")
                        self.showAlert(message: "Error adding route. Please try again.")
                    } else {
                        print("Route added successfully!")
                        self.navigateToCreatedStepsViewController(with: routeName)
                    }
                }
            }
            
            func navigateToCreatedStepsViewController(with routeName: String) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let createdStepsVC = storyboard.instantiateViewController(withIdentifier: "CreatedStepsViewController") as? CreatedStepsViewController {
                    createdStepsVC.routeName = routeName
                    navigationController?.pushViewController(createdStepsVC, animated: true)
                }
            }
            
            func showAlert(message: String) {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
