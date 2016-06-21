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
        htmlParserWithKanna("http://www.elreha.de/technische-handbucher-archiv/")
        
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
            
             //Search for nodes by XPath
                        //for link in doc.xpath("//td[@class='views-field views-field-field-test']") {
                        for link in doc.xpath("//td[@class='column-1']") {
                            print(link.text)
                            //print(link["href"])
                            //let text = link.text
                            dataParse += link.text!.componentsSeparatedByString("")
                        }
            
//            for link in doc.css("table, tbody, tr, td, strong") {
//                print(link.text)
//                //let text = link.text
//                dataParse += link.text!.componentsSeparatedByString(" ")
//            }
            print("DATA =", dataParse)
            
            self.dataList = dataParse
            self.tableView.reloadData()
        }
    }
    
    func reloadDataList(){
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            return
        }
    }


}

