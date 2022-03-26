//
//  AppConstants.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import Foundation

struct AppConstants {
    static let apiKey = "Bearer pVsDVsr01tInNWBJAzOVdpHXLziseRLVKuGw-FejC9RriegZt16nCOOg2_LJgw8fpaIarBcHbLKb80w4PGfr9imQTqI_mvLDWSWtqYlaIOquvzEt4Uxh5sq_Hfo0YXYx"
    static let baseUrl = "https://api.yelp.com/v3/businesses/search"
}

enum AppError: Error {
    case urlError
    case networkError
    case jsonDecodingError
    case unableToFindLocation
    
    var errorMessage: String {
        switch self {
        case .urlError:
            return "Sorry for the inconvience. Will get back soon."
        case .networkError:
            return "Your internent connection is not reachable."
        case .jsonDecodingError:
             return "Sorry for the inconvience. Will get back soon."
        case .unableToFindLocation:
            return "Please enable location from settings."
        }
    }
}
