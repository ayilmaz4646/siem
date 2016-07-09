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

    var dataNameList = [String]()
    var dataLinkList = [String]()
    var dataParse = [String]()
    var linkTitle = NSMutableString()
    var link = NSMutableString()
    var dataList2 = NSMutableArray()
    var dataParse2 = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        searchBar.delegate = self
//        tableView.dataSource = self
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "mycell")
//        dataNameList = ["ses", "ddddd"]
//        dataLinkList = ["llll", "iiii"]
        htmlParserWithKanna("http://www.elreha.de/technische-handbucher-archiv/")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataNameList.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("mycell")! as UITableViewCell
        //let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "mycell")
        cell.textLabel?.text = dataNameList[indexPath.row]
        cell.detailTextLabel?.text = dataLinkList[indexPath.row]
        //cell.textLabel?.text = dataList2.objectAtIndex(indexPath.row) as? NSString as? String
        
        return cell
    
    }
    
    func htmlParserWithKanna(url:String)
    {
        
        if let doc = Kanna.HTML(url: (NSURL(string: url)!), encoding: NSUTF8StringEncoding) {
            for tbl_tr in doc.xpath("//table[@id='tablepress-4']/tbody/tr") {

                let link_label = tbl_tr.css("td:nth-child(1)").text
                let link_url   = tbl_tr.xpath("td[@class='column-2']/a/@href").text

                if ((link_url) != ""){
                    print("Url Geldiii...")
                    dataNameList += link_label!.componentsSeparatedByString("")
                    dataLinkList += link_url!.componentsSeparatedByString("")
                }
                print("Geldiii...")
                print(link_label)
                print(link_url)
                //dataList2.insertObject(link_label!, atIndex: 0)
            }
//            print("DATA =", dataList2)
            
            //self.dataList.append(dataList2.componentsJoinedByString(""))
        }
        
        
    }
    
    func reloadDataList(){
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            return
        }
    }


}

