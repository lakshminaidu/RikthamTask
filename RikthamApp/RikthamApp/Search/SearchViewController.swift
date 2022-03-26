//
//  SearchViewController.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var restaurantTable: UITableView!
        
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantTable.dataSource = self
        restaurantTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func categoryOptionAction(_ sender: UIButton) {
        [locationButton, categoryButton].forEach {
            $0?.backgroundColor = .clear
            $0?.setTitleColor(.black, for: .normal)
        }
        sender.backgroundColor = .systemPink
        sender.setTitleColor(.white, for: .normal)
        let filterType: FilterType = (sender == locationButton ? .location : .category)
        viewModel.filtertype = filterType
        let data = (sender == locationButton ? viewModel.locations : viewModel.categories)
        guard let controller = AppRouter.category(data).controller() as? CategoryViewController else {return}
        controller.didSelect = { opt in
            self.viewModel.updateFilter(key: opt)
            self.restaurantTable.reloadData()
        }
        self.present(controller, animated: true, completion: nil)

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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.business?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.className, for: indexPath) as? SearchCell {
            cell.data = viewModel.business?[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = viewModel.business?[indexPath.row]
        let controller = AppRouter.detail(data).controller()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showloader(state: true)
        viewModel.fetchBusiness(term: searchText, completion: { [weak self] in
            self?.showloader(state: false)
            self?.restaurantTable.reloadData()
        })

    }
}

class SearchCell: UITableViewCell {
    @IBOutlet weak var businessImageView: NetworkImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categories: UILabel!

    var data: Business? {
        didSet {
            if let url = data?.imageURL {
                businessImageView.loadImageWithUrl(url)
            }
            nameLabel.text = data?.name
            addressLabel.text = data?.fullAddress
            categories.text = data?.categoriesName
        }
    }

}
