//
//  SearchStepViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit

class SearchStepViewController: UIViewController {
    
    @IBOutlet weak var seachStepTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonClick))
        
        

        
    }
    @objc func addButtonClick (){
        performSegue(withIdentifier:"toMapKitVC", sender: nil)
    }
    
       
    }
    

    


