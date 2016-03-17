//
//  ApiClient.swift
//  QiitaViewer
//
//  Created by 住田祐樹 on 2016/02/24.
//  Copyright © 2016年 sumida. All rights reserved.
//

import Alamofire
import SwiftyJSON
import ObjectMapper

class ApiClient {
    var articles: [Article] = []

    func getArticles(page: Int, query: String = "") {
        var params:[String: AnyObject] = ["page": page]
        if (query != "") {
            params["query"] = query.stringByReplacingOccurrencesOfString(" ", withString: "+")
        }

        self.articles = []

        Alamofire.request(.GET, "https://qiita.com/api/v2/items", parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    if let articles = value as? NSArray {
                        for article in articles {
                            if article as? NSDictionary != nil {
                                self.articles.append(Mapper<Article>().map(article)!)
                            }
                        }
                    }
                case .Failure(let error):
                    print(error)
                }

                NSNotificationCenter.defaultCenter().postNotificationName("GotArticles", object: nil, userInfo:nil)
        }
    }
}