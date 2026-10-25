//
//  UserViewModel.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

class UserViewModel: NSObject, ObservableObject {
    @Published var user = UserModel()
    @Published var locationManager = CLLocationManager()
    @Published var locationPermissionGranted = false
    @Published var manualLocation = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        loadUserData()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    func saveUserData() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userData")
        }
    }
    
    func loadUserData() {
        if let data = UserDefaults.standard.data(forKey: "userData"),
           let decoded = try? JSONDecoder().decode(UserModel.self, from: data) {
            user = decoded
        }
    }
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "userData")
        user = UserModel()
    }
    
    var isProfileComplete: Bool {
        user.age != nil && user.gender != nil && 
        (user.location != nil || !manualLocation.isEmpty)
    }
}

extension UserViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        user.coordinates = location.coordinate
        
        // Reverse geocode to get city/zip
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let zip = placemark.postalCode ?? ""
                self?.user.location = "\(city), \(state) \(zip)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationPermissionGranted = true
        case .denied, .restricted:
            locationPermissionGranted = false
        default:
            break
        }
    }
}

