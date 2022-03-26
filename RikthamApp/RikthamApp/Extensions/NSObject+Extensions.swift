//
//  NSObject+Extensions.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import Foundation
extension NSObject {
    public static var className: String {
        return String(describing: self.self)
    }
}

protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Optional where Wrapped: Defaultable {
    var unwrappedValue: Wrapped { return self ?? Wrapped.defaultValue }
}

extension Int: Defaultable {
    static var defaultValue: Int { return 0 }
}

extension String: Defaultable {
    static var defaultValue: String { return "" }
}

extension Array: Defaultable {
    static var defaultValue: Array<Element> { return [] }
}
