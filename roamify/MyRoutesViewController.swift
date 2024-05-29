//
//  MyRoutesViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class MyRoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myRoutesTableView: UITableView!
    
    let db = Firestore.firestore()
    var routes: [String] = []
    let userId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRoutesTableView.delegate = self
        myRoutesTableView.dataSource = self
        
        if let userId = userId {
            let userRoutesCollection = db.collection("users").document(userId).collection("routes")
            
            userRoutesCollection.getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching routes: \(error.localizedDescription)")
                    self?.showAlert(message: "Error fetching routes. Please try again.")
                } else {
                    self?.routes = snapshot?.documents.compactMap { $0.data()["routeName"] as? String } ?? []
                    self?.myRoutesTableView.reloadData()
                }
            }
        } else {
            showAlert(message: "User is not logged in.")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath)
        cell.textLabel?.text = routes[indexPath.row]
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let routeNameToDelete = routes[indexPath.row]
            
            
            guard let userId = userId else {
                showAlert(message: "User is not logged in.")
                return
            }
            
            let userRoutesCollection = db.collection("users").document(userId).collection("routes")
            let routeDocument = userRoutesCollection.whereField("routeName", isEqualTo: routeNameToDelete)
            
            routeDocument.getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error deleting route: \(error.localizedDescription)")
                    self?.showAlert(message: "Error deleting route. Please try again.")
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete()
                    }
                    
                   
                    self?.routes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
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
