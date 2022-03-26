//
//  UIView+Extensions.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import Foundation
import UIKit
// MARK: - StoryBoardManage
protocol StoryBoardManage {
    static func instantiate() -> Self
}

extension StoryBoardManage where Self: UIViewController {
    
    static func instantiate() -> Self {
        guard let screnn =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Self.className) as? Self else {
            fatalError("\(self.className) controller not found on Main")
        }
        return screnn
    }
}

// MARK: - showOKAlert
extension UIViewController {
    
    func showOKAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAppError(_ error: AppError) {
        self.showOKAlert(title: "Alert", message: error.errorMessage)
    }
}


// MARK: - UIView.cornerRadius
@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
}

// MARK: - UIApplication.rootVC
extension UIApplication {
    static var rootVC: UIViewController? {
        return Self.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
    }
}
