//
//  LocationManager.swift
//  Capsula
//
//  Created by SherifShokry on 12/5/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//


import UIKit
import CoreLocation
import Moya

class LocationManager: NSObject, CLLocationManagerDelegate {

    var manager : CLLocationManager!
    var locationManagerClosures: [((_ userLocation: CLLocation) -> ())] = []
    private let provider = MoyaProvider<DeliveryManRegistrationDataSource>()
    
    override init() {
    self.manager = CLLocationManager()
    super.init()
    self.manager.delegate = self
    self.manager.allowsBackgroundLocationUpdates = true
    self.manager.showsBackgroundLocationIndicator = true
    self.manager.pausesLocationUpdatesAutomatically = false
        self.manager.activityType = .fitness
//    self.manager.distanceFilter = 1
    self.manager.requestAlwaysAuthorization()
    self.manager.startUpdatingLocation()
        
    }
    
    //This is the main method for getting the users location and will pass back the usersLocation when it is available
    func getlocationForUser(userLocationClosure: @escaping ((_ userLocation: CLLocation) -> ())) {
    
    self.locationManagerClosures.append(userLocationClosure)
    
    //First need to check if the apple device has location services availabel. (i.e. Some iTouch's don't have this enabled)
    if CLLocationManager.locationServicesEnabled() {
    //Then check whether the user has granted you permission to get his location
   
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
    //Request permission
    //Note: you can also ask for .requestWhenInUseAuthorization
       manager.requestAlwaysAuthorization()
    }
        else if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied {
    //... Sorry for you. You can huff and puff but you are not getting any location
    sendFakeLocation()
    //                manager.requestWhenInUseAuthorization()
    } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
    // This will trigger the locationManager:didUpdateLocation delegate method to get called when the next available location of the user is available
    manager.startMonitoringSignificantLocationChanges()
    }
    }else{
        
        
            manager.requestAlwaysAuthorization()
        }
    
        
    }
    
    func sendFakeLocation(){
        
        
    let location = CLLocation.init(latitude: CLLocationDegrees.init("30.0444")!, longitude: CLLocationDegrees.init("31.2357")!)
    let tempClosures = self.locationManagerClosures
    for closure in tempClosures {
    closure(location)
    }
    self.locationManagerClosures = []
    }
    
    //MARK: CLLocationManager Delegate methods
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways || status == .authorizedWhenInUse {
    manager.startMonitoringSignificantLocationChanges()
    }
    }
    
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let userLocation = locations.last{
    let tempClosures = self.locationManagerClosures
    for closure in tempClosures {
    closure(userLocation)
    }
       
          self.geocode(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) { placemark, error in
                        guard let placemark = placemark, error == nil else { return }
            
        let locationRequest = LocationRequest()
        locationRequest.latitude = userLocation.coordinate.latitude
        locationRequest.longitude = userLocation.coordinate.longitude

        locationRequest.addressDesc = (placemark.thoroughfare ?? "") + " " + (placemark.subThoroughfare ?? "")
          
            
            self.provider.request(.updateLocation(locationRequest)) { [weak self] result in
                          //  guard let self = self else { return }
                            switch result {
                            case .success(_):
                               //  completionHandler(.newData)
                                break
                            case .failure(_):
                               //   completionHandler(.newData)
                                break
                            }
                        }
                    }
        
    self.locationManagerClosures = []
    }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
    sendFakeLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    //Because multiple methods might have called getlocationForUser: method there might me multiple methods that need the users location.
    //These userLocation closures will have been stored in the locationManagerClosures array so now that we have the users location we can pass the users location into all of them and then reset the array.
    let tempClosures = self.locationManagerClosures
    for closure in tempClosures {
    closure(newLocation)
    }
    self.locationManagerClosures = []
    }
    
    
      func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
          CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
      }
      
    
    
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        
        
    }
    
}

