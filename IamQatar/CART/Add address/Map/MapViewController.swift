//
//  MapViewController.swift
//  IamQatar
//
//  Created by Anuroop Kanayil on 24/06/20.
//  Copyright © 2020 alisons. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol MapVcDelegate {
    func locationSelected(locationData:NSDictionary)
}

class MapViewController: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var selectBtnView: UIView!
    @IBOutlet weak var locationDetailsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationDetailsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationDetailsViewBottemConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var marketImageHcenterConstraints: NSLayoutConstraint!
    @IBOutlet weak var imgMarker: UIImageView!
    
    //MARK:- VATIABLES
    var currentLocation = CLLocation()
    var locationSelectionDelegte : MapVcDelegate?
    var selectedLat = ""
    var selectedLong = ""
    var selectedLocationName = ""
    var locality = ""
    var country = ""
    var postalCode = ""
    var area = ""
    let locationManager = CLLocationManager()

    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedLat = "\(self.currentLocation.coordinate.latitude)"
        self.selectedLong = "\(self.currentLocation.coordinate.longitude)"
        
        self.getAddressFromLatLong()
        self.setCurruntLocation()
        
        
        self.setUi()
    }
    
    
    //MARK:- METHODS
    func setUi(){
        
        self.lblAddress.text = "..."
        
        //let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 18.0)
        
        //self.mapView.camera = camera
        //mapView.settings.zoomGestures = false
        mapView.delegate = self
        
    }
    
    
    func setCurruntLocation(){
        
        // Ask for Authorisation from the User.
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
//        self.locationManager.delegate = self
//        self.locationManager.requestWhenInUseAuthorization()
//
//
//        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//                 CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//
//             if let location = locationManager.location{
//
//                let currentLocation = location
//
//
//             }
//        }
        
    }

    
    //MARK:- BTN ACTIONS
    @IBAction func doneAction(_ sender: UIButton) {
        
        //self.dismiss(animated: true, completion: nil)
        
        let locationData = ["lat":self.selectedLat,
                            "long":self.selectedLong,
                            "location_name":self.selectedLocationName,
                            "area":self.area,
                            "pincode":self.postalCode,
                            "country":self.country,
                            "locality":self.locality] as NSDictionary
        
        self.locationSelectionDelegte?.locationSelected(locationData: locationData)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    

    @IBAction func searchForLocationAction(_ sender: UIButton) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
        
    }
    

}

extension MapViewController : GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool){
        
        //self.selectBtnView.isHidden = true
        //Vibration.light.vibrate()
        UIView.animate(withDuration: 0.2) {
            self.marketImageHcenterConstraints.constant = -34//-10
            //self.locationDetailsViewBottemConstraint.constant = -self.locationDetailsViewHeightConstraint.constant
            //self.locationDetailsView.alpha = 0
            
            //self.view.layoutIfNeeded()
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        //self.selectBtnView.isHidden = false
        //Vibration.light.vibrate()
        
        UIView.animate(withDuration: 0.2) {
            
            self.marketImageHcenterConstraints.constant = -24//0
            //self.locationDetailsViewBottemConstraint.constant = 0
            self.locationDetailsView.alpha = 1
            self.view.layoutIfNeeded()
            
        }
        
        let centerlocation = mapView.projection.coordinate(for: mapView.center)
               
        self.selectedLat = "\(centerlocation.latitude)"
        self.selectedLong = "\(centerlocation.longitude)"
        
        
        self.getAddressFromLatLong()
    }
    
    func getAddressFromLatLong() {
                
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(self.selectedLat)")!
        //21.228124
        let lon: Double = Double("\(self.selectedLong)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
//            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//            let ceo: CLGeocoder = CLGeocoder()
//            center.latitude = location.coordinate.latitude
//            center.longitude = location.coordinate.longitude

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]

                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                        self.selectedLocationName = pm.subLocality!
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                        self.area = pm.thoroughfare!
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                        self.locality = pm.locality!
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                        self.country = pm.country!
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                        self.postalCode = pm.postalCode!
                    }

                    print(addressString)
                    
                    addressString = addressString == "" ? "Dropped pin" : addressString
                    
                    self.lblAddress.text = addressString
                    self.lblAddress.sizeToFit()
                    //self.locationDetailsViewHeightConstraint.constant = self.lblAddress.frame.height + 36
                    self.view.layoutIfNeeded()
              }
        })
        

    }
    
}

extension MapViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.setMapPosition(lat: locValue.latitude, lang: locValue.longitude)
    }
    
    
    
}


extension MapViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "null")")
        //self.textFieldSearch.text = place.formattedAddress
        print("Place attributions: \(String(describing: place.attributions))")

        self.setMapPosition(lat: place.coordinate.latitude, lang: place.coordinate.longitude)
        
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error.localizedDescription)")
        //self.dismiss(animated: true, completion: nil)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setMapPosition(lat: Double, lang: Double){
        
//        userLat = lat
//        userLong = lang
        
        print(lat)
        print(lang)
        
        
        let camera: GMSCameraPosition
        camera = GMSCameraPosition.camera(withLatitude: lat , longitude: lang , zoom: 16.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
    
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lang)

        //marker.map = mapView
        //marker.icon = #imageLiteral(resourceName: "RedMark")
        mapView.selectedMarker = marker
        
    }
}
