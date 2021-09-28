//
//  Post.swift
//  URLSession
//
//  Created by Артем Хребтов on 28.09.2021.
//

import Foundation

struct Post: Codable {
    //структура поста с jsonplaseholder
    let id: Int
    let title: String
    let body: String
    let userId: Int
    //Инициализируем
    init?(json: [String:Any]){
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String,
            let userId = json["userId"] as? Int
        else { return nil }
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
    //получаем на вход что-то и преобразуем его в массив. Учитываем что аламофаер выдает нам [String:Any]
    static func getArray(jsonArray: Any) -> [Post]? {
        guard let jsonArray = jsonArray as? Array<[String:Any]> else { return nil }
        var posts: [Post] = []

                for jsonObject in jsonArray {
                    if let post = Post(json: jsonObject) {
                        posts.append(post)
                    }
                }
                return posts
    }
}


