//
//  SearchRoutesViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//
import UIKit
import Firebase

class SearchRouteViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var searchRouteTableView: UITableView!
    
    var routes: [String] = []
       var filteredRoutes: [String] = []
       var searchQuery: String?

    override func viewDidLoad() {
            super.viewDidLoad()
            
            searchRouteTableView.delegate = self
            searchRouteTableView.dataSource = self
            
            fetchRoutes { [weak self] routes in
                guard let self = self else { return }
                self.routes = routes
                self.filterRoutes()
                self.searchRouteTableView.reloadData()
            }
        }
       
    func fetchRoutes(completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        db.collection("routes").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                var routes: [String] = []
                for document in snapshot!.documents {
                    routes.append(document.documentID)
                    print("Fetched route: \(document.documentID)")
                }
                completion(routes)
            }
        }
    }

    func filterRoutes() {
        if let query = searchQuery, !query.isEmpty {
            filteredRoutes = routes.filter { $0.lowercased().contains(query.lowercased()) }
        } else {
            filteredRoutes = routes
        }
        print("Filtered routes: \(filteredRoutes)")
    }

        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text
        print("Search Query: \(searchQuery ?? "nil")")
        filterRoutes()
        searchRouteTableView.reloadData()
    }

       // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredRoutes.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "searchRouteCell", for: indexPath)
           cell.textLabel?.text = filteredRoutes[indexPath.row]
           return cell
       }
       
       // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedRoute = filteredRoutes[indexPath.row]
           let stepVC = SearchStepViewController()
           stepVC.routeName = selectedRoute
           navigationController?.pushViewController(stepVC, animated: true)
       }
   }
