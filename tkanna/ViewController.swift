//
//  ViewController.swift
//  tkanna
//
//  Created by Ahmet Yilmaz on 18/06/16.
//  Copyright © 2016 Ahmet Yilmaz. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var dataList = [String]()
    var dataParse = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "mycell")
        dataList = ["ses", "ddddd"]
//        htmlParserWithKanna("http://www.elreha.de/technische-handbucher-archiv/")
        if let doc = Kanna.HTML(url: (NSURL(string: "http://www.elreha.de/technische-handbucher-archiv/")!), encoding: NSUTF8StringEncoding) {
            
            // Search for nodes by XPath
            //            for link in doc.xpath("/html/body/section/div/section/article/div[1]/div[2]/div/table/tbody/tr[1]/td[1]") {
            //            for link in doc.xpath("/html/body") {
            //                print(link.text)
            //                print(link["href"])
            //            }
            
            for link in doc.css("table, tbody, tr, td, strong") {
                print(link.text)
                //let text = link.text
                dataParse += link.text!.componentsSeparatedByString(" ")
            }
            print("DATA =", dataParse)
            
            self.dataList = dataParse
            self.tableView.reloadData()
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataList.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("mycell")! as UITableViewCell
        //let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "mycell")
        cell.textLabel?.text = dataList[indexPath.row]
        
        return cell
    
    }
    
    func htmlParserWithKanna(url:String)
    {
        
        if let doc = Kanna.HTML(url: (NSURL(string: url)!), encoding: NSUTF8StringEncoding) {
            
            // Search for nodes by XPath
            //            for link in doc.xpath("/html/body/section/div/section/article/div[1]/div[2]/div/table/tbody/tr[1]/td[1]") {
            //            for link in doc.xpath("/html/body") {
            //                print(link.text)
            //                print(link["href"])
            //            }
            
            for link in doc.css("table, tbody, tr") {
                print(link.text)
              //print(link["strong"])
                let text = link.text! as String
                self.dataList.append(text)
                self.reloadDataList()
            }

        }
    }
    
    func reloadDataList(){
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            return
        }
    }


}

