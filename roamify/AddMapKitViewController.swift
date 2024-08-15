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
        var routeID: String?
        var stepName: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Add Map"

            guard let routeID = routeID else {
                print("Error: routeID is missing.")
                return
            }

            let userId = Auth.auth().currentUser?.uid
            let stepsCollection = db.collection("users").document(userId!).collection("routes").document(routeID).collection("steps")
            
            stepsCollection.document(stepName ?? "").getDocument { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching map data: \(error.localizedDescription)")
                } else if let mapData = snapshot?.data(),
                          let latitude = mapData["latitude"] as? Double,
                          let longitude = mapData["longitude"] as? Double {
                    let pinLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.addPinToMap(pinLocation)
                }
            }

            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            mapView.addGestureRecognizer(longPressGesture)
        }

        func addPinToMap(_ location: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }

        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                let touchPoint = gestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                addPinToMap(coordinate)
                saveStepToFirebase(coordinate)
            }
        }

        func saveStepToFirebase(_ coordinate: CLLocationCoordinate2D) {
            guard let routeID = routeID, let stepName = stepName, let userId = Auth.auth().currentUser?.uid else { return }

            let stepData: [String: Any] = [
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude
            ]
            
            let stepRef = db.collection("users").document(userId).collection("routes").document(routeID).collection("steps").document(stepName)
            
            stepRef.setData(stepData) { error in
                if let error = error {
                    print("Error saving step: \(error.localizedDescription)")
                } else {
                    print("Step saved successfully!")
                    self.navigateToStepDetailsViewController()
//                    self.performSegue(withIdentifier: "toStepDetailsVC", sender: nil)
                }
            }
        }

        func navigateToStepDetailsViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let stepDetailsVC = storyboard.instantiateViewController(withIdentifier: "StepDetailsViewController") as? StepDetailsViewController {
                stepDetailsVC.routeID = self.routeID
                stepDetailsVC.stepName = self.stepName
                navigationController?.pushViewController(stepDetailsVC, animated: true)
            }
        }
    }
