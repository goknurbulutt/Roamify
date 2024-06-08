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
    
    @IBOutlet weak var object: UIImageView!
    @IBOutlet weak var stepNameTextField: UITextField!
    @IBOutlet weak var stepNoteTextField: UITextField!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Adım Detayları"
        
        if let stepDetails = stepDetails {
            stepNameTextField.text = stepDetails["stepName"] as? String
            stepNoteTextField.text = stepDetails["note"] as? String
        }
    }
    
    @IBAction func doneClicked(_ sender: UIButton) {
        guard let stepName = stepNameTextField.text, !stepName.isEmpty else {
            showAlert(message: "Adım adı boş olamaz.")
            return
        }
        
        guard let note = stepNoteTextField.text else {
            showAlert(message: "Not boş olamaz.")
            return
        }

        let stepData: [String: Any] = ["stepName": stepName, "note": note]
        let userId = Auth.auth().currentUser?.uid

        db.collection("users").document(userId!).collection("steps").addDocument(data: stepData) { error in
            if let error = error {
                print("Adım detayları eklenirken hata: \(error.localizedDescription)")
                self.showAlert(message: "Adım detayları eklenirken hata oluştu. Lütfen tekrar deneyin.")
            } else {
                print("Adım detayları başarıyla eklendi!")
                self.showSuccessAlert(message: "Adım detayları başarıyla eklendi!")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Başarılı", message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
