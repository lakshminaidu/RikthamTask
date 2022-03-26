//
//  BusinessDeatailController.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import UIKit

class BusinessDeatailController: BaseViewController {
    @IBOutlet weak var imageView: NetworkImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var selectedBusines: Business?
    
    override func viewDidLoad() {
      super.viewDidLoad()
        updateUI()
        if !(BusinessDB.shared.fetchData().map{$0.id}.contains(self.selectedBusines?.id ?? "")) {
            BusinessDB.shared.save(business: selectedBusines!)
        }
        
    }

    func updateUI() {
        imageView.loadImageWithUrl((selectedBusines?.imageURL).unwrappedValue)
        nameLabel.text = selectedBusines?.name
        addressLabel.text = "Address: " + (selectedBusines?.fullAddress).unwrappedValue
        phoneLabel.text = "Phone: " + (selectedBusines?.phone).unwrappedValue
        priceLabel.text = "Price: " + (selectedBusines?.price).unwrappedValue
        ratingLabel.text = "Rating: " + (selectedBusines?.rating?.description ?? "")

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
