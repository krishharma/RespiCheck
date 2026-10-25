//
//  UserModel.swift
//  PnScreener
//
//  Created on 11/11/2025.
//

import Foundation
import CoreLocation

struct UserModel: Codable {
    var age: Int?
    var gender: Gender?
    var location: String?
    var coordinates: CLLocationCoordinate2D?
    var insuranceType: InsuranceType
    var language: AppLanguage
    
    enum Gender: String, Codable, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
        case preferNotToSay = "Prefer not to say"
    }
    
    enum InsuranceType: String, Codable, CaseIterable {
        case privateInsurance = "Private Insurance"
        case medicaid = "Medicaid"
        case uninsured = "Uninsured"
        case unknown = "Unknown"
    }
    
    enum AppLanguage: String, Codable, CaseIterable {
        case english = "English"
        case spanish = "Español"
        case mandarin = "中文"
        
        var code: String {
            switch self {
            case .english: return "en"
            case .spanish: return "es"
            case .mandarin: return "zh"
            }
        }
    }
    
    init() {
        self.insuranceType = .unknown
        self.language = .english
    }
}

// Extension to handle CLLocationCoordinate2D encoding
extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}

