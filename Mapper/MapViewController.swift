//
//  ViewController.swift
//  Mapper
//
//  Created by hollarab on 2/24/16.
//  Copyright © 2016 a. brooks hollar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMapView.delegate = self
        centerMapOnLocation(initialLocation)
        addWestminsterQuake()
    
        
        DataStore.sharedInstance.loadData()
    }
    
    func addWestminsterQuake() {
        let quake = Earthquake(id: 1, long: -105.0372, lat: 39.8361, mag: 1.3, date: NSDate(), place: "DaVinci Coders")
        let annotation = EarthquakeAnotation(earthquake: quake)
        myMapView.addAnnotation(annotation)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    // MARK: - Inital Location
    let regionRadius: CLLocationDistance = 5_000_000                                // 5 Million Meters - underscores are convenience
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)   // Honalulu, HI
//    let initialLocation = CLLocation(latitude: 39.8361, longitude: -105.0372)      // Westminster, CO

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
}

// MARK: - Navigation and Unwind seques
extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EarthquakeAnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView?
            if let dequeueView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeueView.annotation = annotation
                view = dequeueView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                view?.calloutOffset = CGPoint(x: -5, y: -5)
                view?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                
                
            }
            return view!
        }
        return nil
    }
    
    @IBAction func infoButtonTouched(sender:AnyObject) {
        performSegueWithIdentifier("Info", sender: self)
    }
    
    @IBAction func mapInfoDismissed(segue:UIStoryboardSegue) {
        print("unwind segues reached")
    }
}

