//
//  LocationViewController.swift
//  Opportunity
//
//  Created by Jake Runzer on 2016-02-29.
//  Copyright © 2016 FixCode. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var fulltitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        if subtitle != "" {
            fulltitle = "\(title) - \(subtitle)"
        } else {
            fulltitle = title
        }
    }
}

class LocationViewController: ConditionViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addressLabel: DesignableLabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: AutoCompleteTextField!
    
    var locationManager: CLLocationManager!
    let regionRadius: CLLocationDistance = 1000
    
    var mapItems: [MKMapItem] = [MKMapItem]()
    var currentAnnotations: [MapPin] = [MapPin]()
    var selectedPoint: MapPin?
    
    var firstSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    
        if condition != nil {
            
        }
        
        configureTextField()
        self.searchTextField.autoCompleteStrings = nil
        handleTextFieldInterfaces()
        
        self.searchTextField.becomeFirstResponder()
        
//        addRadiusCircle(initialLocation)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureTextField(){
        searchTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        searchTextField.autoCompleteTextFont = UIFont(name: "Avenir-Book", size: 14.0)
        searchTextField.autoCompleteCellHeight = 35.0
        searchTextField.maximumAutoCompleteCount = 20
        searchTextField.hidesWhenSelected = true
        searchTextField.hidesWhenEmpty = true
        searchTextField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        searchTextField.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        self.searchTextField.onTextChange = {text in
            if !text.isEmpty{
                self.searchAddress(text)
            }
        }
        
        self.searchTextField.onSelect = {text, indexpath in
            self.getCoordinateForAddress(text, completion: nil)
        }
    }
    
    func getCoordinateForAddress(search: String, completion: (()->())?) {
        Location.geocodeAddressString(search, completion: { (placemark, error) -> Void in
            if let coordinate = placemark?.location?.coordinate{
                let annotation = MapPin(coordinate: coordinate, title: search, subtitle: "")
                if self.selectedPoint != nil {
                    self.mapView.removeAnnotation(self.selectedPoint!)
                }
                self.mapView.removeAnnotations(self.currentAnnotations)
                self.currentAnnotations.removeAll()
                
                self.mapView.addAnnotation(annotation)
                self.centerMapOnCoordinate(coordinate)
                self.selectedPoint = annotation
                self.searchTextField.autoCompleteStrings = nil
                
                if completion != nil {
                    completion!()
                }
            }
        })
    }
    
    func searchAddress(text: String) {
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = text
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler({
            response, error in
            
            guard let response = response else {
                print("Search error: \(error)")
                return
            }
            
            var searchStrings = [String]()
            
            self.mapView.removeAnnotations(self.currentAnnotations)
            self.currentAnnotations.removeAll()
            
            for item in response.mapItems {
//                print(item.placemark.addressDictionary!)
//                searchStrings.append(item.name!)
                let addressString = item.name!
                var street = item.placemark.addressDictionary!["Street"] != nil ? item.placemark.addressDictionary!["Street"]! : ""
                if street as! String == addressString {
                    street = ""
                }
                
                let annotation = MapPin(coordinate: item.placemark.coordinate, title: addressString, subtitle: street as! String)
                searchStrings.append(annotation.fulltitle!)
                self.mapView.addAnnotation(annotation)
                self.currentAnnotations.append(annotation)
            }
            self.searchTextField.autoCompleteStrings = searchStrings
        })
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        if !firstSet {
            centerMapOnLocation(location)
            firstSet = true
        }
//        centerMapOnLocation(location)
    }
    
    func centerMapOnCoordinate(coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        centerMapOnCoordinate(location.coordinate)
    }
    
    func addRadiusCircle(location: CLLocation){
        let circle = MKCircle(centerCoordinate: location.coordinate, radius: 50 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor(red: 115, green: 92, blue: 221, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        }
        return MKPolylineRenderer()
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let mapPin = view.annotation as? MapPin {
            self.mapView.removeAnnotations(self.currentAnnotations)
            self.currentAnnotations.removeAll()
            self.selectedPoint = mapPin
            self.searchTextField.text = mapPin.fulltitle!
            self.searchTextField.autoCompleteStrings = nil
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let mapPin = annotation as? MapPin {
            let aView = MKPinAnnotationView(annotation: mapPin, reuseIdentifier: "")
            let arrowImage = UIImage(named: "arrow")!
            let button = UIButton(type: UIButtonType.DetailDisclosure)
            button.setImage(arrowImage, forState: UIControlState.Normal)
            aView.rightCalloutAccessoryView = button
            aView.canShowCallout = true
            return aView
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? MapPin {
//            self.selectedPoint = annotation
        }
    }
    
    override func createCondition() {
        let completion: ()->() = {
            let value = "\(self.selectedPoint!.title) - \(self.selectedPoint!.subtitle)|\(self.selectedPoint!.coordinate.latitude)|\(self.selectedPoint!.coordinate.longitude)"
            let message = "\(self.selectedPoint!.fulltitle!)"
            self.createUpdateCondition(LOCATION, value: value, message: message)
        }
        
        if selectedPoint == nil {
            if self.selectedPoint == nil || self.searchTextField.text! == "" {
                self.addressLabel.animation = "shake"
                self.addressLabel.animate()
                return
            }
            getCoordinateForAddress(searchTextField.text!, completion: completion)
        } else {
            completion()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
