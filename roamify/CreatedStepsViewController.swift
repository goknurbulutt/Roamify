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
    var routeName: String?
    var steps: [Step] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = routeName
        stepTableView.dataSource = self
        stepTableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))

        guard let routeName = routeName, !routeName.isEmpty else {
            showAlert(message: "Route name cannot be empty.")
            return
        }
        
        let userId = Auth.auth().currentUser?.uid
        let userRoutesCollection = db.collection("users").document(userId!).collection("routes")

        userRoutesCollection.document(routeName).collection("steps").addSnapshotListener { snapshot, error in
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

            guard let routeName = self.routeName else {
                self.showAlert(message: "Route name is missing.")
                return
            }

            let newStep: [String: Any] = [
                "stepName": stepName,
                "note": "" 
            ]

            let userId = Auth.auth().currentUser?.uid
            let userRoutesCollection = self.db.collection("users").document(userId!).collection("routes")

            userRoutesCollection.document(routeName).collection("steps").addDocument(data: newStep) { error in
                if let error = error {
                    self.showAlert(message: "Error adding step: \(error.localizedDescription)")
                } else {
                    print("Step added successfully!")
                }
            }

            self.performSegue(withIdentifier: "toAddMapKitVC", sender: ["routeName": routeName, "stepName": stepName])
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
               let routeName = data["routeName"],
               let stepName = data["stepName"] {
                addMapKitVC.routeName = routeName
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
