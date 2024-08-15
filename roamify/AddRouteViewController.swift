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
     }
     
     @IBAction func doneClicked(_ sender: UIButton) {
         guard let routeName = routeNameTextField.text, !routeName.isEmpty else {
             showAlert(message: "Please enter a route name.")
             return
         }
         
         let userRoutesCollection = db.collection("users").document(userId!).collection("routes")
         
         // Rota belgesi oluşturuluyor
         let newRouteRef = userRoutesCollection.document()
         newRouteRef.setData(["routeName": routeName]) { error in
             if let error = error {
                 print("Error adding route: \(error.localizedDescription)")
                 self.showAlert(message: "Error adding route. Please try again.")
             } else {
                 print("Route added successfully!")
                 self.navigateToCreatedStepsViewController(with: newRouteRef.documentID, routeName: routeName)

             }
         }
     }
     
    func navigateToCreatedStepsViewController(with routeID: String, routeName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let createdStepsVC = storyboard.instantiateViewController(withIdentifier: "CreatedStepsViewController") as? CreatedStepsViewController {
            createdStepsVC.routeID = routeID
            createdStepsVC.routeName = routeName  // Route name diğer sayfadaki tittle için gönderiliyor
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
