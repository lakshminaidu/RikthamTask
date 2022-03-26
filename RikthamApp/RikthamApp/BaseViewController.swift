//
//  BaseViewController.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import UIKit

class BaseViewController: UIViewController, StoryBoardManage {
    
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    // setup the view
    func setup() {
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .purple
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - User defined
    /// toggle the loader
    func showloader(state: Bool) {
        if state == true {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

enum AppRouter {
    case search(CategoryType)
    case detail(Business?)
    case category([String])
    
    func controller() -> BaseViewController {
        switch self {
        case .search(let option):
            let controller = SearchViewController.instantiate()
            let viewModel = SearchViewModel()
            viewModel.selectedOption = option
            controller.viewModel = viewModel
            return controller
        case .detail(let business):
            let controller = BusinessDeatailController.instantiate()
            controller.selectedBusines = business
            return controller
        case .category(let data):
            let controller = CategoryViewController.instantiate()
            controller.options = data
            return controller
        }
    }
}
