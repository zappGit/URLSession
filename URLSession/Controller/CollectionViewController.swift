//
//  CollectionViewController.swift
//  URLSession
//
//  Created by Артем Хребтов on 23.09.2021.
//

import UIKit

enum Buttons: String, CaseIterable {
    case get = "Get"
    case post = "Post"
    case downloadImage = "Download Image"
}

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    var actions = Buttons.allCases
    let url = "https://jsonplaceholder.typicode.com/posts"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.row].rawValue
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .downloadImage:
            performSegue(withIdentifier: "image", sender: self)
                
        }
    }

}
