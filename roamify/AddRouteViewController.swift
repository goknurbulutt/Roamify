//
//  AddRouteViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import Firebase

class AddRouteViewController: UIViewController {
    
    @IBOutlet weak var object: UIImageView!
    
    @IBOutlet weak var howDoesLabel: UITextView!
    
    @IBOutlet weak var routeNameTextField: UITextField!
    let db = Firestore.firestore()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  

    @IBAction func doneClicked(_ sender: UIButton) {
        
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User ID is nil.")
            return
        }
        
        let userRoutesCollection = db.collection("users").document(userID).collection("routes")
        
        if let routeName = routeNameTextField.text {
               
                let routeData: [String: Any] = [
                    "routeName": routeName,
                    
                ]

            userRoutesCollection.addDocument(data: routeData) { error in
                    if let error = error {
                        print("Error adding route: \(error.localizedDescription)")
                    } else {
                        print("Route added successfully!")
                        DispatchQueue.main.async{
                            let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tolga") as! CreatedStepsViewController
                            UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                            print("Route added successfully2!")
                        }
                       }
                }
            }
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toCreatedStepsVC" {
                if let createdStepsVC = segue.destination as? CreatedStepsViewController {
                    createdStepsVC.routeName = routeNameTextField.text
                }
            }
        }
    
    
    }

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
