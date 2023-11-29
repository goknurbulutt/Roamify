//
//  StepDetailsViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class StepDetailsViewController: UIViewController {
    
    @IBOutlet weak var object: UIImageView!
    
    @IBOutlet weak var stepNameTextField: UITextField!
    
    @IBOutlet weak var stepNoteTextField: UITextField!
    let db = Firestore.firestore()

        override func viewDidLoad() {
            super.viewDidLoad()
            // Eğer bir resim göstermek istiyorsanız, aşağıda resmi yükleyebilirsiniz
            // object.image = UIImage(named: "your_image_name")
        }

        @IBAction func doneClicked(_ sender: UIButton) {
            if let stepName = stepNameTextField.text, let note = stepNoteTextField.text {
                // Firebase'e adım detaylarını ekleyebilirsiniz
                db.collection("steps").addDocument(data: ["stepName": stepName, "note": note]) { error in
                    if let error = error {
                        print("Error adding step details: \(error.localizedDescription)")
                    } else {
                        print("Step details added successfully!")
                        // Gerekirse başka işlemler
                    }
                }
            }
        }
    }
