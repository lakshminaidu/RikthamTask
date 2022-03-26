//
//  RikthamAppTests.swift
//  RikthamAppTests
//
//  Created by Lakshminaidu on 25/3/2022.
//

import XCTest
import CoreLocation

@testable import RikthamApp
class RikthamAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBusinessSearch() {
        let model = BusinessSearch.testModel
        XCTAssertTrue(model.total == 1)
        let bModel = Business.testModel
        XCTAssertTrue(bModel.name == "Test")
    }
    
    func testHomeViewModel() {
        let model = HomeViewModel()
        XCTAssertTrue(model.business == nil)
        XCTAssertTrue(model.numberofSections == 2)
        model.business = [Business.testModel, Business.testModel, Business.testModel]
        XCTAssertTrue(model.numberofSections == 2)
        XCTAssertTrue(model.numberofRows == 2)
        model.didSelectAll = true
        XCTAssertTrue(model.numberofSections == 1)
        XCTAssertTrue(model.numberofRows == 3)
        
    }
    
    func testHomeViewModel_ViewAll() {
        let model = HomeViewModel()
        model.business = [Business.testModel, Business.testModel, Business.testModel]
        model.didSelectAll = true
        XCTAssertTrue(model.numberofSections == 1)
        XCTAssertTrue(model.numberofRows == 3)
        
    }
    
    func testEndPont() {
        let model = BusinessRequestModel(term: nil, location: CLLocation(latitude: 1.11, longitude: 2.222), category: .restaurant, sortBy: .distance)
        let url =  model.url?.absoluteString ?? ""
        XCTAssertTrue(!url.contains("term="))
        
        let termModel = BusinessRequestModel(term: "food", location: CLLocation(latitude: 1.11, longitude: 2.222), category: .restaurant, sortBy: .distance)
        let termurl =  termModel.url?.absoluteString ?? ""
        XCTAssertTrue(termurl.contains("term=food"))

    }
    
    func testHomeViewModelData() {
        
        let homeModel = HomeViewModel(networkService: MockNetwork.shared, locationService: LocationService.shared)
        let expectation = expectation(description: "Loading business")
        homeModel.fetchNearbyRestaurants(completion: {
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3)
       
        XCTAssertEqual((homeModel.business?.count).unwrappedValue, 1)
        
    }

    func testSearchViewModelData() {
        
        let searchModel = SearchViewModel(networkService: MockNetwork.shared)
        searchModel.selectedOption = .restaurant
        
        let expectation = expectation(description: "Loading business")
        searchModel.fetchBusiness(term: "h", completion: {
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3)
        XCTAssertEqual((searchModel.business?.count).unwrappedValue, 1)
        XCTAssertEqual((searchModel.dataCopy?.count).unwrappedValue, 1)
        searchModel.filtertype = .location
        
        XCTAssertEqual(searchModel.locations.count, 1)
        
    }

}

extension BusinessSearch {
    static let testModel: Self = Self(
       businesses: [.testModel],
       total: 1,
       region: Region(center: Center(latitude: 27.12344,
                                     longitude: -80.12345))
     )
}

extension Business {
    static var testModel: Business {
        return Business(id: UUID().uuidString, name: "Test", rating: 5.0, price: "$22", phone: "123456789", categories: [Category(alias: "asdas", title: "asdasd")], imageURL: "testUrl", location: Location(city: "london", country: "UK", address2: "lonaon", address3: "london", state: nil, address1: "asdasds", zipCode: "12345", displayAddress: ["asdasd", "sadasd"]), distance: 2)
    }
}


class MockNetwork: NetworkServiceType {
    static let shared = MockNetwork()
    var business = BusinessSearch.testModel
    func request<T>(with endPoint: YelpEndPoint, completion: @escaping (Envelope<T>) -> ()) where T : Decodable, T : Encodable {
        completion(.success(BusinessSearch.testModel as! T))
    }
}
