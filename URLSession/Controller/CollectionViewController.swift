//
//  CollectionViewController.swift
//  URLSession
//
//  Created by Артем Хребтов on 23.09.2021.
//

import UIKit

enum Buttons: String, CaseIterable {
   case getAlamofire = "Get Alamo"
    case postAlamofire = "Post Alamofore"
    case get = "Get"
    case post = "Post"
    case downloadImage = "Download Image"
    case downloadFile = "Download File"
}

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    var actions = Buttons.allCases
    let url = "https://jsonplaceholder.typicode.com/posts"
    private let dataProvider = DataProvider()
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
        case .downloadFile:
            dataProvider.startDownload()
            showAlert()
        case .getAlamofire:
            performSegue(withIdentifier: "posts", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "postRequest", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tvc = segue.destination as? TableViewController
        switch segue.identifier {
        case "posts":
            tvc?.getRequest()
        case "postRequest":
            tvc?.postRequest()
        default:
            break
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Download...", message: "0%", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancel)
        //для того чтобы увеличить размеры алерт контроллера. обращаемся ко вью алерта!
        let height = NSLayoutConstraint(item: alert.view as Any,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 200)
        //присваиваем созданный констрайнт к алерту
        alert.view.addConstraint(height)
        
        present(alert, animated: true){
            //тут можно создавать новые элементы внутри алерта
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: alert.view.frame.width/2 - size.width / 2, y: alert.view.frame.height/2 - size.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .blue
            activityIndicator.startAnimating()
            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                        y: alert.view.frame.height - 44,
                                                        width: alert.view.frame.width,
                                                        height: 5))
            progressView.tintColor = .green
            
            self.dataProvider.total = { progress in
                progressView.progress = Float(progress)
                alert.message = String(Int(progress * 100)) + "%"
                
                if progressView.progress == 1 {
                    alert.dismiss(animated: true, completion: nil)
                }
                
            }
            
            alert.view.addSubview(activityIndicator)
            alert.view.addSubview(progressView)
        }
        
    }

}
