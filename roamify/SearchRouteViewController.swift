//
//  SearchRoutesViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//
import UIKit
import Firebase

class SearchRouteViewController: UITableViewController {
    
  
    @IBOutlet weak var searchRouteTableView: UITableView!
    
    var routes: [String] = []
       var filteredRoutes: [String] = []
       var searchQuery: String?

       override func viewDidLoad() {
           super.viewDidLoad()
           
           searchRouteTableView.delegate = self
           searchRouteTableView.dataSource = self
           
           fetchRoutes { [weak self] routes in
               self?.routes = routes
               self?.filterRoutes()
               self?.searchRouteTableView.reloadData()
           }
       }
       
       func fetchRoutes(completion: @escaping ([String]) -> Void) {
           let db = Firestore.firestore()
           var routes: [String] = []
           
           db.collection("routes").getDocuments { (snapshot, error) in
               if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   for document in snapshot!.documents {
                       routes.append(document.documentID)
                   }
                   completion(routes)
               }
           }
       }
       
       func filterRoutes() {
           if let query = searchQuery {
               filteredRoutes = routes.filter { $0.lowercased().contains(query.lowercased()) }
           } else {
               filteredRoutes = routes
           }
       }
       
       // UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredRoutes.count
       }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "searchRouteCell", for: indexPath)
           cell.textLabel?.text = filteredRoutes[indexPath.row]
           return cell
       }
       
       // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedRoute = filteredRoutes[indexPath.row]
           let stepVC = SearchStepViewController()
           stepVC.routeName = selectedRoute
           navigationController?.pushViewController(stepVC, animated: true)
       }
   }
