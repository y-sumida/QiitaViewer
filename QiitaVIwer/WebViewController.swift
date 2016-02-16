//
//  webviewController.swift
//  QiitaVIwer
//
//  Created by 住田祐樹 on 2016/02/16.
//  Copyright © 2016年 sumida. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var url:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "記事本文"
        print(self.url)

    }

}
