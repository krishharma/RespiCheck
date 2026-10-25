//
//  ProviderModel.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import Foundation
import CoreLocation

struct ProviderModel: Identifiable, Codable {
    let id: UUID
    let name: String
    let address: String
    let phoneNumber: String
    let distance: Double // in miles
    let acceptsInsurance: [UserModel.InsuranceType]
    let languagesSupported: [UserModel.AppLanguage]
    let hours: String
    let hasTelemedicine: Bool
    let coordinates: CLLocationCoordinate2D
    
    init(
        id: UUID = UUID(),
        name: String,
        address: String,
        phoneNumber: String,
        distance: Double,
        acceptsInsurance: [UserModel.InsuranceType],
        languagesSupported: [UserModel.AppLanguage],
        hours: String,
        hasTelemedicine: Bool,
        coordinates: CLLocationCoordinate2D
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.distance = distance
        self.acceptsInsurance = acceptsInsurance
        self.languagesSupported = languagesSupported
        self.hours = hours
        self.hasTelemedicine = hasTelemedicine
        self.coordinates = coordinates
    }
    
    // Sample mock providers
    static let mockProviders: [ProviderModel] = [
        ProviderModel(
            name: "Community Health Center",
            address: "123 Main Street, Your City, ST 12345",
            phoneNumber: "555-0100",
            distance: 1.2,
            acceptsInsurance: [.medicaid, .privateInsurance, .uninsured],
            languagesSupported: [.english, .spanish],
            hours: "Mon-Fri 8AM-6PM, Sat 9AM-1PM",
            hasTelemedicine: true,
            coordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        ),
        ProviderModel(
            name: "City Medical Clinic",
            address: "456 Oak Avenue, Your City, ST 12345",
            phoneNumber: "555-0200",
            distance: 2.8,
            acceptsInsurance: [.medicaid, .privateInsurance],
            languagesSupported: [.english, .spanish, .mandarin],
            hours: "Mon-Sat 7AM-8PM",
            hasTelemedicine: true,
            coordinates: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094)
        ),
        ProviderModel(
            name: "Free Health Clinic Network",
            address: "789 Elm Street, Your City, ST 12345",
            phoneNumber: "555-0300",
            distance: 3.5,
            acceptsInsurance: [.medicaid, .uninsured],
            languagesSupported: [.english, .spanish],
            hours: "Tue-Thu 9AM-5PM",
            hasTelemedicine: false,
            coordinates: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294)
        ),
        ProviderModel(
            name: "Downtown Urgent Care",
            address: "321 Pine Boulevard, Your City, ST 12345",
            phoneNumber: "555-0400",
            distance: 4.1,
            acceptsInsurance: [.privateInsurance, .medicaid],
            languagesSupported: [.english],
            hours: "Daily 8AM-10PM",
            hasTelemedicine: true,
            coordinates: CLLocationCoordinate2D(latitude: 37.7549, longitude: -122.4394)
        ),
        ProviderModel(
            name: "Neighborhood Family Practice",
            address: "654 Cedar Lane, Your City, ST 12345",
            phoneNumber: "555-0500",
            distance: 5.3,
            acceptsInsurance: [.privateInsurance],
            languagesSupported: [.english, .mandarin],
            hours: "Mon-Fri 9AM-5PM",
            hasTelemedicine: false,
            coordinates: CLLocationCoordinate2D(latitude: 37.7949, longitude: -122.3994)
        )
    ]
}

