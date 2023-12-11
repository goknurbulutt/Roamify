//
//  AddMapKitViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import MapKit
import Firebase

class AddMapKitViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let db = Firestore.firestore()
        var selectedRouteName: String?
    var routeName: String?
    var stepName: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            title = selectedRouteName
            
            guard let selectedRouteName = selectedRouteName, !selectedRouteName.isEmpty else {
                print("Hata: selectedRouteName boş veya nil.")
                // Hata ile başa çıkın veya kullanıcıya bir uyarı gösterin
                return
            }

            // Şimdi, selectedRouteName'i kullanarak Firestore'dan veri çekebilirsiniz
            db.collection("routes").document(selectedRouteName).getDocument { snapshot, error in
                // Mevcut kodunuz...
            }


            // Firebase'den harita verilerini çekebilirsin
            db.collection("routes").document(selectedRouteName ?? "").getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching map data: \(error.localizedDescription)")
                } else {
                    // Snapshot'tan harita verilerini çek ve haritaya pin ekle
                    if let mapData = snapshot?.data(),
                       let latitude = mapData["latitude"] as? Double,
                       let longitude = mapData["longitude"] as? Double {
                        let pinLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.addPinToMap(pinLocation)
                    }
                }
            }
        }
    
    

        // Haritada yer eklemek için bir fonksiyon ekleyebilirsin
        func addPinToMap(_ location: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }
    
    func showAlert(message: String) {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
    
    @objc func addButtonClick() {
        // Eğer routeName boş veya nil ise kullanıcıya hata mesajı göster
        guard let routeName = routeName, !routeName.isEmpty else {
            showAlert(message: "Route name cannot be empty.")
            return
        }

        // Firestore'a rota adını ekle
        db.collection("routes").document(routeName).setData(["routeName": routeName]) { error in
            if let error = error {
                print("Error adding route: \(error.localizedDescription)")
                // Hata durumunda kullanıcıya bilgi ver
                self.showAlert(message: "Error adding route. Please try again.")
            } else {
                print("Route added successfully to Firestore")
                // Başarı durumunda kullanıcıya bilgi ver
                self.showAlert(message: "Route added successfully.")
                
                // Firestore'a rota adını ekledikten sonra segue'yi başlat
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toAddMapKitVC", sender: routeName)
                }
            }
        }
    }


    // prepare fonksiyonunu güncelle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddMapKitVC" {
            if let addMapKitVC = segue.destination as? AddMapKitViewController,
               let routeName = sender as? String {
                addMapKitVC.routeName = routeName
            }
        }
    }

    }
