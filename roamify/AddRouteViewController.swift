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
                
                guard let userID = Auth.auth().currentUser?.uid else {
                    print("User ID is nil.")
                    return
                }

                // Firestore'da "users" koleksiyonu içinde kullanıcının altında bir koleksiyon oluştur
                let userRoutesCollection = db.collection("users").document(userID).collection("routes")

                // Kullanıcının altındaki "routes" koleksiyonuna rota ekleyebilirsin
                let routeData: [String: Any] = [
                    "routeName": routeName,
                    
                ]

            userRoutesCollection.addDocument(data: routeData) { error in
                    if let error = error {
                        print("Error adding route: \(error.localizedDescription)")
                    } else {
                        print("Route added successfully!")

                    
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "toCreatedStepsVC", sender: self)
                            // CreatedStepsViewController'ı sunma kodu burada
                        }
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
