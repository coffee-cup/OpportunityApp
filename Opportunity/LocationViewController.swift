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
    @IBOutlet weak var mapBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: DesignableLabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: AutoCompleteTextField!
    
    var locationManager: CLLocationManager!
    let regionRadius: CLLocationDistance = 1000
    
    var mapItems: [MKMapItem] = [MKMapItem]()
    var currentAnnotations: [MapPin] = [MapPin]()
    var selectedPoint: MapPin?
    
    var firstSet = false
    let MAP_ANIMATION = 0.500
    
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
        
        // set values if we are editing an existing condition
        if condition != nil {
            let mapPin = ConditionParser.parseLocation(condition!.value!)
            self.selectedPoint = mapPin
            self.searchTextField.text = mapPin.fulltitle!
            self.centerMapOnCoordinate(mapPin.coordinate)
            self.mapView.addAnnotation(mapPin)
            firstSet = true
        }
        
        // configure auto complete
        configureTextField()
        self.searchTextField.autoCompleteStrings = nil
        handleTextFieldInterfaces()
        
        // get keyboard height when it comes up
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        
        // hide keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        mapView.addGestureRecognizer(tapGesture)
        
        //        addRadiusCircle(initialLocation)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.mapBottomConstraint.constant = frame.height
        UIView.animateWithDuration(MAP_ANIMATION, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: {finished in
                self.mapFitAllPoints()
        })
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
    
    func getCoordinateForAddress(text: String, completion: (()->())?) {
        var search = text
        var title = text
        var subtitle = ""
        if text.containsString("-") {
            let values = text.componentsSeparatedByString("-")
            title = values[0]
            subtitle = values[1]
            search = subtitle
        }
        
        Location.geocodeAddressString(search, completion: { (placemark, error) -> Void in
            if let coordinate = placemark?.location?.coordinate {
                let annotation = MapPin(coordinate: coordinate, title: title, subtitle: subtitle)
                if self.selectedPoint != nil {
                    self.mapView.removeAnnotation(self.selectedPoint!)
                }
                self.mapView.removeAnnotations(self.currentAnnotations)
                self.currentAnnotations.removeAll()
                
                self.mapView.addAnnotation(annotation)
                self.centerMapOnCoordinate(coordinate)
                self.selectedPoint = annotation
                self.searchTextField.text = self.selectedPoint!.fulltitle!
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
            
            if self.selectedPoint != nil {
                self.mapView.removeAnnotation(self.selectedPoint!)
            }
            self.mapView.removeAnnotations(self.currentAnnotations)
            self.currentAnnotations.removeAll()
            
            if text != "" {
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
                self.mapFitAllPoints()
                self.searchTextField.autoCompleteStrings = searchStrings
            }
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
    
    func mapFitAllPoints() {
        var zoomRect = MKMapRectNull
        for annotation in mapView.annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
            if MKMapRectIsNull(zoomRect) {
                zoomRect = pointRect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        }
        if zoomRect.size.width > 100 && zoomRect.size.height > 100 {
            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 10, right: 10), animated: true)
        }
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
            self.mapView.addAnnotation(mapPin)
            self.searchTextField.text = mapPin.fulltitle!
            self.searchTextField.autoCompleteStrings = nil
            self.centerMapOnCoordinate(mapPin.coordinate)
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
            let value = "\(self.selectedPoint!.fulltitle!)|\(self.selectedPoint!.coordinate.latitude)|\(self.selectedPoint!.coordinate.longitude)"
            let message = "\(self.selectedPoint!.fulltitle!)"
            self.createUpdateCondition(LOCATION, value: value, message: message)
        }
        
        if self.selectedPoint == nil || self.searchTextField.text! == "" {
            self.addressLabel.animation = "shake"
            self.addressLabel.animate()
            return
        }
        
        if selectedPoint == nil {
            getCoordinateForAddress(searchTextField.text!, completion: completion)
        } else {
            completion()
        }
    }
    
    func hideKeyboard() {
        searchTextField.resignFirstResponder()
        
        self.mapBottomConstraint.constant = 0
        UIView.animateWithDuration(MAP_ANIMATION / 2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: {finished in
                self.mapFitAllPoints()
        })
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
