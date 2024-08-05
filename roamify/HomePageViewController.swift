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
      
      var searchText: String?

      override func viewDidLoad() {
          super.viewDidLoad()
          searchBar.delegate = self
      }
      
//      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//          addNewRouteButton.isHidden = true
//          myRoutesButton.isHidden = true
//      }
//      
//      func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//          addNewRouteButton.isHidden = false
//          myRoutesButton.isHidden = false
//      }
      
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              self.searchText = searchText
              print("Arama metni: \(searchText)")
              performSegue(withIdentifier:"toSearchRoutesVC", sender: self)
          }
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "toSearchRoutesVC" {
              if let destinationVC = segue.destination as? SearchRouteViewController {
                  destinationVC.searchQuery = searchText
              }
          }
      }

      @IBAction func addNewRouteClicked(_ sender: Any) {
          performSegue(withIdentifier:"toAddRouteVC", sender: self)
      }
      
      @IBAction func myRoutesClicked(_ sender: Any) {
          // My Routes işlemleri burada olacak
      }
  }
