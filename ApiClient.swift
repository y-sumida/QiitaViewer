//
//  ApiClient.swift
//  QiitaVIwer
//
//  Created by 住田祐樹 on 2016/02/24.
//  Copyright © 2016年 sumida. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ApiClient {
    var articles: [[String: String?]] = []

    func getArticles(page: Int) {
        Alamofire.request(.GET, "https://qiita.com/api/v2/items", parameters: ["page": page])
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }

                let json = JSON(object)
                json.forEach { (_, json) in
                    let article: [String: String?] = [
                        "title": json["title"].string,
                        "userId": json["user"]["id"].string,
                        "url": json["url"].string
                    ]
                    self.articles.append(article)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("GotArticles", object: nil, userInfo:nil)
        }
    }
}