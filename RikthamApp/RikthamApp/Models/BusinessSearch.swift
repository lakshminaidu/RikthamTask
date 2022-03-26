//
//  BusinessModel.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import Foundation

// MARK: - BusinessSearch
struct BusinessSearch: Codable {
    let businesses: [Business]?
    let total: Int?
    let region: Region?
}

// MARK: - Business
struct Business {
    let id: String
    let name: String?
    let rating: Double?
    let price, phone: String?
    let categories: [Category]?
    let imageURL: String?
    let location: Location?
    let distance: Double?
    var categoriesName: String? {
        categories?.compactMap ({ $0.title }).joined(separator: ", ")
    }
    var fullAddress: String? {
        location?.displayAddress?.compactMap ({ $0 }).joined(separator: ", ")
    }
    var city: String? {
        return location?.city
    }
}

extension Business: Codable, Equatable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        rhs.id == lhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case rating, price, phone, id
        case categories
        case imageURL = "image_url"
        case location, distance
    }
}


// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Center
struct Center: Codable, Equatable {
    let latitude, longitude: Double?
}

// MARK: - Location
struct Location: Codable {
    let city, country, address2, address3: String?
    let state, address1, zipCode: String?
    let displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case city, state, country, address2, address3, address1
        case zipCode = "zip_code"
        case displayAddress = "display_address"
        
    }
}
// MARK: - Region
struct Region: Codable, Equatable {
    let center: Center?
}

