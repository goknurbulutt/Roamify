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

            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))
            
            func addStepToFirestore(stepName: String, stepNote: String) {
                    // Rota adını kontrol et
                    guard let routeName = routeName, !routeName.isEmpty else {
                        showAlert(message: "Route name cannot be empty.")
                        return
                    }

                    // Adım verilerini Firestore'a eklemek için kullanılacak sözlük
                    let stepData: [String: Any] = [
                        "stepName": stepName,
                        "note": stepNote
                    ]
                print("routeName: \(routeName)")

                    // Firestore'a veriyi ekle
                    db.collection("routes").document(routeName).collection("steps").addDocument(data: stepData) { error in
                        if let error = error {
                            print("Error adding step: \(error.localizedDescription)")
                            // Hata durumunda kullanıcıya bilgi ver
                            self.showAlert(message: "Error adding step. Please try again.")
                        } else {
                            print("Step added successfully to Firestore")
                            // Başarı durumunda kullanıcıya bilgi ver
                            self.showAlert(message: "Step added successfully.")
                            // Firestore'a veri ekledikten sonra lokal diziyi güncelle
                            self.addStep(name: stepName, note: stepNote)
                            self.stepTableView.reloadData()
                        }
                    }
                }


            // Firebase'den adım verilerini çekebilirsin
            db.collection("routes").document(routeName ?? "").collection("steps").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching steps: \(error.localizedDescription)")
                } else {
                    // Snapshot'tan adım verilerini çek ve steps dizisine ekle
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

        // UITableViewDataSource ve UITableViewDelegate fonksiyonları
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return steps.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath)
            let step = steps[indexPath.row]
            cell.textLabel?.text = step.name
            cell.detailTextLabel?.text = step.note
            return cell
        }

        // Step eklemek için bir fonksiyon ekleyebilirsin
        func addStep(name: String, note: String) {
            let step = Step(name: name, note: note)
            steps.append(step)
        }

        // @objc func addButtonClick() {
        //     performSegue(withIdentifier: "toAddMapKitVC", sender: nil)
        // }

        // Eğer toAddMapKitVC sayfasına geçiş yapılacaksa, bu fonksiyon kullanılabilir.
        @objc func addButtonClick() {
            // Eğer routeName boş veya nil ise kullanıcıya hata mesajı göster
            guard let routeName = routeName, !routeName.isEmpty else {
                showAlert(message: "Route name cannot be empty.")
                return
            }

            performSegue(withIdentifier: "toAddMapKitVC", sender: nil)
        }

        // Hata mesajı gösterme fonksiyonu
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }

    

        

    

    


