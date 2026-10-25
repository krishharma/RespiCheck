//
//  ProviderMatchViewModel.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

class ProviderMatchViewModel: ObservableObject {
    @Published var providers: [ProviderModel] = []
    @Published var filteredProviders: [ProviderModel] = []
    @Published var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    @Published var selectedProvider: ProviderModel?
    
    func loadProviders(for user: UserModel) {
        // Load mock providers
        providers = ProviderModel.mockProviders
        
        // Filter based on user's insurance and location
        filterProviders(by: user.insuranceType, language: user.language)
        
        // Update map region if user has coordinates
        if let coordinates = user.coordinates {
            mapPosition = .region(
                MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
        }
    }
    
    func filterProviders(by insurance: UserModel.InsuranceType, language: UserModel.AppLanguage) {
        filteredProviders = providers.filter { provider in
            // Match insurance
            let insuranceMatch = provider.acceptsInsurance.contains(insurance) || 
                                insurance == .unknown
            
            // Match language
            let languageMatch = provider.languagesSupported.contains(language)
            
            return insuranceMatch && languageMatch
        }
        
        // If no matches found, show all providers
        if filteredProviders.isEmpty {
            filteredProviders = providers
        }
        
        // Sort by distance
        filteredProviders.sort { $0.distance < $1.distance }
    }
    
    func makePhoneCall(to phoneNumber: String) {
        let cleanNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if let url = URL(string: "tel://\(cleanNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func openMaps(for provider: ProviderModel) {
        let coordinate = provider.coordinates
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = provider.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

