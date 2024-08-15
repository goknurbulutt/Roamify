//
//  HomePageViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit

class HomePageViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
      @IBOutlet weak var addNewRouteButton: UIButton!
      @IBOutlet weak var myRoutesButton: UIButton!
    @IBOutlet weak var routeDetailsTableView: UITableView!
    
      var searchText: String?

      override func viewDidLoad() {
          super.viewDidLoad()
          searchBar.delegate = self
      }
      

      
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              self.searchText = searchText
              print("Arama metni: \(searchText)")
             
          }
      }
      
     

      @IBAction func addNewRouteClicked(_ sender: Any) {
          performSegue(withIdentifier:"toAddRouteVC", sender: self)
      }
      
      @IBAction func myRoutesClicked(_ sender: Any) {
          // My Routes işlemleri burada olacak
      }
  }
