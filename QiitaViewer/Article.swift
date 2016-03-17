//
//  Article.swift
//  QiitaViewer
//
//  Created by 住田祐樹 on 2016/03/17.
//  Copyright © 2016年 sumida. All rights reserved.
//

import Foundation
import ObjectMapper

struct Article: Mappable {
    var title: String?
    var userId: String?
    var url: String?
    
    init?(_ map: Map){}
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        userId <- map["user.id"]
        url <- map["url"]
    }
}
