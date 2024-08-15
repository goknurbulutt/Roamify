//
//  StepDetailsViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class StepDetailsViewController: UIViewController {
    
    var stepDetails: [String: Any]?
    var routeID: String?
    var stepName: String?

    @IBOutlet weak var object: UIImageView!
    @IBOutlet weak var stepNameTextField: UITextField!
    @IBOutlet weak var stepNoteTextField: UITextField!
   
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Step Details"
        
        // Eğer stepDetails varsa, stepName ve note'u doldur
        if let stepDetails = stepDetails {
            stepNameTextField.text = stepDetails["stepName"] as? String
            stepNoteTextField.text = stepDetails["note"] as? String
        } else if let stepName = stepName {
            // Eğer stepDetails yoksa, sadece stepName verilerini yükle
            stepNameTextField.text = stepName
        }
    }
    
    @IBAction func doneClicked(_ sender: UIButton) {
        // Step name ve note boş olamaz, bunları kontrol ediyoruz
        guard let stepName = stepNameTextField.text, !stepName.isEmpty else {
            showAlert(message: "Step name cannot be empty.")
            return
        }
        
        guard let note = stepNoteTextField.text else {
            showAlert(message: "Note cannot be empty.")
            return
        }

        // Eğer routeID ve stepName `Optional` değilse, doğrudan kullanabiliriz
        if let routeID = routeID {
            let stepData: [String: Any] = ["stepName": stepName, "note": note]
            let userId = Auth.auth().currentUser?.uid
            
            // Firestore'da adımı belirli bir rotanın altına kaydetme işlemi
            let stepRef = db.collection("users").document(userId!).collection("routes").document(routeID).collection("steps").document(stepName)
            
            stepRef.setData(stepData) { error in
                if let error = error {
                    print("Error adding step details: \(error.localizedDescription)")
                    self.showAlert(message: "Error adding step details. Please try again.")
                } else {
                    print("Step details successfully added!")
                    self.showSuccessAlert(message: "Step details successfully added!")
                }
            }
        } else {
            showAlert(message: "Route ID is missing.")
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: {
                self.navigateToCreatedStepsViewController()
            })
        }
    }
    
    func navigateToCreatedStepsViewController() {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if let createdStepsVC = viewController as? CreatedStepsViewController {
                    navigationController.popToViewController(createdStepsVC, animated: true)
                    return
                }
            }
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
