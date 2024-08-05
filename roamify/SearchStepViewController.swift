//
//  SearchStepViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import FirebaseFirestore

class SearchStepViewController: UIViewController {
    
    @IBOutlet weak var seachStepTableView: UITableView!
    var routeName: String!
      var steps: [String] = []
      
      override func viewDidLoad() {
          super.viewDidLoad()
          fetchSteps(forRoute: routeName) { [weak self] steps in
              self?.steps = steps
              self?.seachStepTableView.reloadData()
          }
      }
      
      func fetchSteps(forRoute routeName: String, completion: @escaping ([String]) -> Void) {
          let db = Firestore.firestore()
          var steps: [String] = []
          
          db.collection("routes").document(routeName).collection("steps").getDocuments { (snapshot, error) in
              if let error = error {
                  print("Error getting documents: \(error)")
              } else {
                  for document in snapshot!.documents {
                      steps.append(document.documentID)
                  }
                  completion(steps)
              }
          }
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return steps.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath)
          cell.textLabel?.text = steps[indexPath.row]
          return cell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let selectedStep = steps[indexPath.row]
          let mapVC = MapKitViewController()
          mapVC.routeName = routeName
          mapVC.stepName = selectedStep
          navigationController?.pushViewController(mapVC, animated: true)
      }
  }
