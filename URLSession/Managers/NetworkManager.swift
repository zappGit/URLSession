//
//  NetworkManager.swift
//  URLSession
//
//  Created by Артем Хребтов on 23.09.2021.
//

import Foundation
import UIKit
import Alamofire

class NetworkManager {
    
    //Download photo
    static func downloadImage(url: String, complition: @escaping (UIImage) -> () ) {
        guard let urlString = URL(string: url) else { return }
        print(urlString)
        let session = URLSession.shared
        session.dataTask(with: urlString) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            print(data)
            DispatchQueue.main.async {
                complition(image)
            }
        }.resume()
    }
    //Get data
    static func getRequest(url: String) {
        guard let urlString = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: urlString) { data, response, error in
            guard let data = data, let response = response else { return }
            print(data)
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()
    }
    //Post data
    static func postRequest(url: String) {
        guard let urlString = URL(string: url) else { return }
        
        let body = ["First" : "1", "Second" : "2", "Third" : "3"]
        
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else { return }
            print(response)
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    //get reauest alamofire
    static func getRequestAlamofire(url: String, complition: @escaping(([Post]) -> ())){
        
        guard let urlString = URL(string: url) else { return }
        
        AF.request(urlString).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var posts = [Post]()
                posts = Post.getArray(jsonArray: value)!
                complition(posts)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    //post request alamofire
    static func postRequestAlamofire(url: String, complition: @escaping(([Post]) -> ())) {
        guard let urlString = URL(string: url) else { return }
        
        let params: [String: Any] = [
            "title": "new post",
            "body": "some news",
            "userId": 10
        ]
        
        AF.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let jsonPost = value as? [String:Any],
                let post = Post(json: jsonPost)
                else {return}
                var posts = [Post]()
                posts.append(post)
                complition(posts)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
