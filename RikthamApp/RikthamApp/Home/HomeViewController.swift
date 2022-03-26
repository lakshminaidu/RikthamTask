//
//  HomeViewController.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var recentsColletionView: UICollectionView!
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    
    var searchOption: CategoryType = .food
    var viewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        showloader(state: true)
        recentsColletionView.delegate = self
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self
        recentsColletionView.dataSource = self

        viewModel.fetchNearbyRestaurants { [weak self] in
            self?.showloader(state: false)
            self?.restaurantCollectionView.reloadData()
            self?.restaurantCollectionView.collectionViewLayout.invalidateLayout()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshRecents()
        recentsColletionView.reloadData()
    }
    
    @IBAction func foodButtonAction(_ sender: UIButton) {
        searchOption = .food
        let controller = AppRouter.search(searchOption).controller()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func restaurantButtonAction(_ sender: UIButton) {
        searchOption = .restaurant
        let controller = AppRouter.search(searchOption).controller()
        self.navigationController?.pushViewController(controller, animated: true)
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == recentsColletionView {
            return 1
        } else {
            return viewModel.numberofSections
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentsColletionView {
            return viewModel.recents.count
        } else {
            return section == 0 ? viewModel.numberofRows : 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = RestaurantCell.className + "\(indexPath.section)"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? RestaurantCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            cell.data = (collectionView == recentsColletionView) ? viewModel.recents[indexPath.row] : viewModel.business?[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let data = (collectionView == recentsColletionView) ? viewModel.recents[indexPath.row] : viewModel.business?[indexPath.row]
            let controller = AppRouter.detail(data).controller()
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            viewModel.didSelectAll = true
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 165)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

class RestaurantCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: NetworkImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    var data: Business? {
        didSet {
            if let url = data?.imageURL {
                imageView.loadImageWithUrl(url)
            }
            cityLabel.text = data?.location?.city
        }
    }
}
