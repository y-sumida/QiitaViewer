//
//  ViewController.swift
//  QiitaVIwer
//
//  Created by 住田祐樹 on 2016/02/09.
//  Copyright © 2016年 sumida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let table = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "新着記事"

        table.frame = view.frame
        view.addSubview(table)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

