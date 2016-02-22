//
//  ViewController.swift
//  QiitaVIwer
//
//  Created by 住田祐樹 on 2016/02/09.
//  Copyright © 2016年 sumida. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let table = UITableView()
    var articles: [[String: String?]] = []
    var page = 1
    var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "新着記事"

        table.frame = view.frame
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self

        //一旦バウンドさせない設定にしてみる
        table.bounces = false

        //セルの高さを動的にするため
        table.estimatedRowHeight = 20
        table.rowHeight = UITableViewAutomaticDimension

        let reloadButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "onClickReloadButton:")
        self.navigationItem.setRightBarButtonItem(reloadButton, animated: false)

        getArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getArticles() {
        print("getArticles\(page)")
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
                //print(self.articles)
                self.isLoading = false
                self.table.reloadData()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row]

        //セルの高さを動的にするため
        cell.textLabel?.numberOfLines = 0

        cell.textLabel?.text = article["title"]!
        cell.detailTextLabel?.text = article["userId"]!

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let article = articles[indexPath.row]
        let url = article["url"]!
        self.showWebView("showWebPage", url: url!)
    }

    func showWebView(next:String, url:String) {

        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let receiveview:WebViewController = storyboard.instantiateViewControllerWithIdentifier(next) as! WebViewController
        receiveview.url = url
        self.navigationController?.pushViewController(receiveview, animated: true)
    }

    func onClickReloadButton(sender: UIButton) {
        page = 1
        articles = []
        //self.table.contentOffset.y = 0
        self.table.reloadData()
        getArticles()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        //TODO これだとアニメーションの分だけ複数回一番下と判断される
        if(self.table.contentOffset.y < (self.table.contentSize.height - self.table.bounds.size.height)) {
            return
        }

        if (self.isLoading) {
            return
        }

        if (!self.table.dragging) {
            return
        }

        self.isLoading = true

        if(self.page++ < 100) {
            self.getArticles()
        }
    }
}

