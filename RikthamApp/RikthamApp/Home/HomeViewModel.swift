//
//  HomeViewModel.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import Foundation
import UIKit
class HomeViewModel {
    var business: [Business]?
    var recents = [Business]()
    private var networkService: NetworkServiceType!
    private var locationService: LocationService!
    var didSelectAll: Bool = false
    
    init(networkService: NetworkServiceType = RikthamApp.NetworkService.shared, locationService: LocationService = LocationService.shared) {
        self.networkService = networkService
        self.locationService = locationService
        self.locationService.startUpdatingLocation()
    }
    
    func fetchNearbyRestaurants(completion: @escaping ()->Void) {
        let reqModel = BusinessRequestModel(term: nil, category: .restaurant)
        networkService.request(with: reqModel) { [weak self]  (result: Envelope<BusinessSearch>) in
            switch result {
            case .success(let res):
                self?.business = res.businesses
                print(res.businesses?.count ?? 0)
                completion()
            case .failure(let err):
                completion()
                UIApplication.rootVC?.showAppError(err)
            }
        }
    }
    
    var numberofSections: Int {
        return didSelectAll ? 1 : 2
    }
    
    var numberofRows: Int {
        if let data = self.business {
            return didSelectAll ? data.count : 2
        } else {
            return 0
        }
    }
    
    func refreshRecents() {
        recents = BusinessDB.shared.fetchData()
    }
}
