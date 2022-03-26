//
//  SearchViewModel.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 26/3/2022.
//

import Foundation
import UIKit
enum FilterType {
    case location
    case category
}
protocol SearchViewModelType: AnyObject {
    var business: [Business]? {get}
    var locations: [String] {get}
    var categories: [String] {get}
    var networkService: NetworkServiceType! {get}
    var selectedOption: CategoryType {get}
    func fetchBusiness(term: String?, completion: @escaping () -> Void)
}

class SearchViewModel: SearchViewModelType {
    var dataCopy: [Business]?
    var business: [Business]?
    var locations: [String] = []
    var categories: [String] = []
    var networkService: NetworkServiceType!
    var selectedOption: CategoryType = .food
    var filtertype: FilterType = .location
    init(networkService: NetworkServiceType = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchBusiness(term: String?, completion: @escaping () -> Void) {
        let reqModel = BusinessRequestModel(term: term, category: selectedOption)
        networkService.request(with: reqModel) { [weak self]  (result: Envelope<BusinessSearch>) in
            switch result {
            case .success(let res):
                self?.business = res.businesses
                self?.dataCopy = res.businesses
                self?.prepareFilterData()
                completion()
            case .failure(let err):
                completion()
                UIApplication.rootVC?.showAppError(err)
            }
        }
    }
    
    func prepareFilterData() {
        guard let data = self.dataCopy else {
            return
        }
        locations = data.compactMap {$0.fullAddress}
        categories = data.compactMap {$0.categoriesName}
    }
    
    func updateFilter(key: String) {
        switch self.filtertype {
        case .location:
            business = dataCopy?.filter {$0.fullAddress == key}
        case .category:
            business = dataCopy?.filter {$0.categoriesName == key}
        }
    }
}
