//
//  MapKitViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.11.2023.
//

import UIKit
import MapKit
import FirebaseFirestore

class MapKitViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate{
    var routeName: String!
       var stepName: String!
       var mapView: MKMapView!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           mapView = MKMapView(frame: self.view.bounds)
           self.view.addSubview(mapView)
           
           fetchStepCoordinates(routeName: routeName, stepName: stepName) { [weak self] latitude, longitude in
               let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
               let annotation = MKPointAnnotation()
               annotation.coordinate = coordinate
               annotation.title = self?.stepName
               self?.mapView.addAnnotation(annotation)
               self?.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
           }
       }
       
       func fetchStepCoordinates(routeName: String, stepName: String, completion: @escaping (Double, Double) -> Void) {
           let db = Firestore.firestore()
           
           db.collection("routes").document(routeName).collection("steps").document(stepName).getDocument { (document, error) in
               if let document = document, document.exists {
                   let data = document.data()
                   let latitude = data?["latitude"] as? Double ?? 0.0
                   let longitude = data?["longitude"] as? Double ?? 0.0
                   completion(latitude, longitude)
               } else {
                   print("Document does not exist")
               }
           }
       }
   }
