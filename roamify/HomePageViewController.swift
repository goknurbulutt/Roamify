//
//  HomePageViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit

class HomePageViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        
        
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if let searchText = searchBar.text {
                // searchText, kullanıcının girdiği metni içerir
                print("Arama metni: \(searchText)")
                performSegue(withIdentifier:"toSearchRoutesVC", sender: self)
                
                
                
                
                
            }
        }
    

    @IBAction func addNewRouteClicked(_ sender: Any) {
        performSegue(withIdentifier:"toAddRouteVC", sender: self)
        
    }
    
    
    
    @IBAction func myRoutesClicked(_ sender: Any) {
        
    }
    
    
    

}
