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
        var routeName: String?
        var stepName: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            title = routeName

            guard let routeName = routeName, !routeName.isEmpty else {
                print("Hata: routeName boş ")
                
                return
            }

            db.collection("routes").document(routeName).getDocument { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching map data: \(error.localizedDescription)")
                } else {
                    if let mapData = snapshot?.data(),
                       let latitude = mapData["latitude"] as? Double,
                       let longitude = mapData["longitude"] as? Double {
                        let pinLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.addPinToMap(pinLocation)
                    }
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
            guard let stepName = stepName, !stepName.isEmpty else {
                showAlert(message: "Step name cannot be empty.")
                return
            }

            let stepData: [String: Any] = [
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude,
                "stepName": stepName
            ]

           
            db.collection("routes").document(routeName ?? "").collection("steps").document(stepName).setData(stepData) { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    print("Error saving step data: \(error.localizedDescription)")
                    self.showAlert(message: "Error saving step data. Please try again.")
                } else {
                    print("Step data saved successfully to Firestore")

                   
                    self.showStepDetails(for: coordinate)
                }
            }
        }
    
    func addPinToMapp(_ location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }


        func showStepDetails(for coordinate: CLLocationCoordinate2D) {
         
            performSegue(withIdentifier: "toStepDetailsVC", sender: ["latitude": coordinate.latitude, "longitude": coordinate.longitude, "stepName": stepName])
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toStepDetailsVC", let stepDetailsVC = segue.destination as? StepDetailsViewController,
               let stepDetails = sender as? [String: Any] {
                stepDetailsVC.stepDetails = stepDetails
            }
        }

        func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
