//
//  CreatedStepsViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class CreatedStepsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var stepTableView: UITableView!
    let db = Firestore.firestore()
        var routeID: String?
        var routeName: String?  // Route name değişkeni
        var steps: [Step] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Rota ismini başlık olarak ayarla
            title = routeName ?? "Steps"
            
            stepTableView.dataSource = self
            stepTableView.delegate = self
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))

            guard let routeID = routeID else {
                showAlert(message: "Route ID cannot be empty.")
                return
            }

            let userId = Auth.auth().currentUser?.uid
            let stepsCollection = db.collection("users").document(userId!).collection("routes").document(routeID).collection("steps")

            // Adımların listelenmesi
            stepsCollection.addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching steps: \(error.localizedDescription)")
                } else {
                    self.steps = []
                    for document in snapshot!.documents {
                        let stepData = document.data()
                        if let name = stepData["stepName"] as? String, let note = stepData["note"] as? String {
                            self.addStep(name: name, note: note)
                        }
                    }
                    self.stepTableView.reloadData()
                }
            }
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return steps.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as? StepTableViewCell else {
                return UITableViewCell()
            }
            let step = steps[indexPath.row]
            cell.stepLabel.text = step.name
            return cell
        }

        func addStep(name: String, note: String) {
            let step = Step(name: name, note: note)
            steps.append(step)
        }

    @objc func addButtonClick() {
        let alertController = UIAlertController(title: "Add Step", message: "Enter step name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Step Name"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self, let stepName = alertController.textFields?.first?.text, !stepName.isEmpty else {
                self?.showAlert(message: "Step name cannot be empty.")
                return
            }

            guard let routeID = self.routeID else {
                self.showAlert(message: "Route ID is missing.")
                return
            }

            let userId = Auth.auth().currentUser?.uid
            let stepsCollection = self.db.collection("users").document(userId!).collection("routes").document(routeID).collection("steps")

            // Belge ID olarak adım adı
            let stepRef = stepsCollection.document(stepName)

            // Belge var mı kontrol
            stepRef.getDocument { document, error in
                if let error = error {
                    self.showAlert(message: "Error checking step: \(error.localizedDescription)")
                } else if document?.exists == true {
                    self.showAlert(message: "A step with this name already exists.")
                } else {
                    let newStep: [String: Any] = [
                        "stepName": stepName,
                        "note": ""
                    ]
                    
                    stepRef.setData(newStep) { error in
                        if let error = error {
                            self.showAlert(message: "Error adding step: \(error.localizedDescription)")
                        } else {
                            print("Step added successfully!")
                            self.performSegue(withIdentifier: "toAddMapKitVC", sender: ["routeID": routeID, "stepName": stepName])
                        }
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }


        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toAddMapKitVC" {
                if let addMapKitVC = segue.destination as? AddMapKitViewController,
                   let data = sender as? [String: String],
                   let routeID = data["routeID"],
                   let stepName = data["stepName"] {
                    addMapKitVC.routeID = routeID
                    addMapKitVC.stepName = stepName
                }
            }
        }

        func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
