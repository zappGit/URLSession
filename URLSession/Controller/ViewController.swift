//
//  ViewController.swift
//  URLSession
//
//  Created by Артем Хребтов on 23.09.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var downloadedImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let url = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }
    
    func fetchImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        NetworkManager.downloadImage(url: url) { image in
            self.activityIndicator.stopAnimating()
            self.downloadedImage.image = image
        }
    }
}
