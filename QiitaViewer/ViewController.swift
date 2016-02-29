
//  ViewController.swift
//  QiitaViewer
//
//  Created by 住田祐樹 on 2016/02/09.
//  Copyright © 2016年 sumida. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let table = UITableView()
    let searchBar = UISearchBar()
    var articles: [[String: String?]] = []
    var page = 1
    let client = ApiClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "新着記事"

        let statusHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navigationheight = self.navigationController?.navigationBar.frame.size.height
        searchBar.frame = CGRectMake(0, 0, self.view.frame.width, 50)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: navigationheight! + statusHeight + searchBar.frame.height / 2)
        searchBar.searchBarStyle = UISearchBarStyle.Default
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.view.addSubview(searchBar)

        table.frame = view.frame
        table.layer.position = CGPoint(x: self.view.bounds.width/2, y: navigationheight! + statusHeight + searchBar.frame.height + table.frame.height / 2)
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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinisedRequest", name: "GotArticles", object: nil)

        self.client.getArticles(self.page)
        self.view.makeToastActivity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didFinisedRequest() {
        self.articles += self.client.articles
        table.reloadData()
        self.view.hideToastActivity()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")

        if (articles.count > indexPath.row) {
            let article = articles[indexPath.row]

            //セルの高さを動的にするため
            cell.textLabel?.numberOfLines = 0

            cell.textLabel?.text = article["title"]!
            cell.detailTextLabel?.text = article["userId"]!

            // 最後のセル表示時にAPIコール
            if ((articles.count) - 1 == indexPath.row && self.page++ < 100) {
                self.client.getArticles(self.page)
            }
        }

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

        self.client.getArticles(self.page)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
    }
}

