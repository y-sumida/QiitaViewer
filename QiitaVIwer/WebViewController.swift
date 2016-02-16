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
    let webview = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.frame = view.frame
        self.view.addSubview(webview)
        
        openWeb()
        
        title = "記事本文"
        print(self.url)

    }
    
    func openWeb() {
        if let url = NSURL(string: self.url) {
            let urlReq = NSURLRequest(URL: url)
            webview.loadRequest(urlReq)
        }
    }

}
