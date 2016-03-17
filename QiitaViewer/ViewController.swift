
//  ViewController.swift
//  QiitaViewer
//
//  Created by 住田祐樹 on 2016/02/09.
//  Copyright © 2016年 sumida. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let table = UITableView()
    let searchBar = UISearchBar()
    var articles: [Article] = []
    var page = 1
    var query = ""
    let client = ApiClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "新着記事"

        let statusHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navigationheight = self.navigationController?.navigationBar.frame.size.height
        self.searchBar.frame = CGRectMake(0, 0, self.view.frame.width, 50)
        self.searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: navigationheight! + statusHeight + self.searchBar.frame.height / 2)
        self.searchBar.searchBarStyle = UISearchBarStyle.Default
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.view.addSubview(self.searchBar)

        self.table.frame = self.view.frame
        self.table.layer.position = CGPoint(x: self.view.bounds.width/2, y: navigationheight! + statusHeight + self.searchBar.frame.height + self.table.frame.height / 2)
        self.view.addSubview(table)
        self.table.dataSource = self
        self.table.delegate = self

        //一旦バウンドさせない設定にしてみる
        self.table.bounces = false

        //セルの高さを動的にするため
        self.table.estimatedRowHeight = 20
        self.table.rowHeight = UITableViewAutomaticDimension

        let reloadButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "onClickReloadButton:")
        self.navigationItem.setRightBarButtonItem(reloadButton, animated: false)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinisedRequest", name: "GotArticles", object: nil)

        self.client.getArticles(self.page)
        self.view.makeToastActivity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func didFinisedRequest() {
        self.articles += self.client.articles
        self.table.reloadData()
        self.view.hideToastActivity()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")

        if (self.articles.count > indexPath.row) {
            let article = self.articles[indexPath.row]

            //セルの高さを動的にするため
            cell.textLabel?.numberOfLines = 0

            if let title = article.title {
                cell.textLabel?.text = title
            }
            
            if let userId = article.userId {
                cell.detailTextLabel?.text = userId
            }

            // 最後のセル表示時にAPIコール
            if ((articles.count) - 1 == indexPath.row && self.page++ < 100) {
                self.client.getArticles(self.page, query: self.query)
                self.view.makeToastActivity()
            }
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let article = self.articles[indexPath.row]
        if let url = article.url {
            self.showWebView("showWebPage", url: url)
        }
        self.searchBar.resignFirstResponder()
    }

    func showWebView(next:String, url:String) {

        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let receiveview:WebViewController = storyboard.instantiateViewControllerWithIdentifier(next) as! WebViewController
        receiveview.url = url
        self.navigationController?.pushViewController(receiveview, animated: true)
    }

    func onClickReloadButton(sender: UIButton) {
        self.page = 1
        self.articles = []
        self.table.reloadData()

        self.client.getArticles(self.page, query: self.query)
        self.view.makeToastActivity()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.page = 1
        self.query = ""
        self.searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.page = 1
        self.articles = []
        self.table.reloadData()
        self.query = self.searchBar.text!

        self.client.getArticles(self.page, query: self.query)
        self.view.makeToastActivity()
        self.view.endEditing(true)
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

