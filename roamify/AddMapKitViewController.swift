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

        override func viewDidLoad() {
            super.viewDidLoad()
            title = selectedRouteName

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
    }
