//
//  CreatedStepsViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit

class CreatedStepsViewController: UIViewController {
    
    
    @IBOutlet weak var stepTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonClick))
        
        

        
    }
    @objc func addButtonClick (){
        performSegue(withIdentifier:"toAddMapKitVC", sender: nil)
        
    }
    

        
    }
    

    


