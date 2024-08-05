//
//  SearchRoutesViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit

class SearchRoutesViewController: UIViewController {
    
    @IBOutlet weak var searchRoutesTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonClick))
        
       

        
    }
    @objc func addButtonClick (){
        performSegue(withIdentifier:"toSearchStepVC", sender: nil)
    }
    

        
    }
    

   


