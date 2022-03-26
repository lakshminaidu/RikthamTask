//
//  ImageView+Extention.swift
//  DogsApp
//
//  Created by Lakshminaidu on 05/03/2021.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class NetworkImageView: UIImageView {
    
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func loadImageWithUrl(_ url: String) {
        
        // setup activityIndicator...
        guard let albumUrl = URL(string: url) else {
            return
        }
        imageURL = albumUrl
        image = nil
        activityIndicator.startAnimating()
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: albumUrl, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == albumUrl {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
}
