//
//  BusinessDBModel+CoreDataProperties.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 26/3/2022.
//
//

import Foundation
import CoreData


extension BusinessDBModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessDBModel> {
        return NSFetchRequest<BusinessDBModel>(entityName: "BusinessDBModel")
    }

    @NSManaged public var businessName: String?
    @NSManaged public var rating: Double
    @NSManaged public var id: String?
    @NSManaged public var price: String?
    @NSManaged public var address: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var phone: String?
    @NSManaged public var city: String?
    @NSManaged public var date: Date?


}

extension BusinessDBModel : Identifiable {

}
