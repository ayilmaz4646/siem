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
    var linkTitle = NSMutableString()
    var link = NSMutableString()
    var dataList2 = NSMutableArray()
    var dataParse2 = NSMutableArray()
    
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
        //cell.textLabel?.text = dataList2.objectAtIndex(indexPath.row) as? NSString as? String
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailsVC = storyboard?.instantiateViewControllerWithIdentifier("detailsViewController") as! detailsViewController
        detailsVC.select(dataList[indexPath.row])
        
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "detailssegue"
//        {
//            
//            var indexpath: NSIndexPath? = nil
//            indexpath = tableView.indexPathForSelectedRow!
//            if let destinationVC = segue.destinationViewController as? detailsViewController {
//                destinationVC.ttitle = dataList[]
//            }
//            
//        }
//        
//    }

    
    func htmlParserWithKanna(url:String)
    {
        
        if let doc = Kanna.HTML(url: (NSURL(string: url)!), encoding: NSUTF8StringEncoding) {
            for tbl_tr in doc.xpath("//table[@id='tablepress-4']/tbody/tr") {

                let link_label = tbl_tr.css("td:nth-child(1)").text
                let link_url   = tbl_tr.xpath("td[@class='column-2']/a/@href").text
                
            //for link in doc.xpath("//td[@class='column-1']") {
                print("Geldiii...")
                print(link_label)
                print(link_url)
                //print(link["href"])
                //let text = link.text
                //dataParse += link.text!.componentsSeparatedByString("")
                //dataParse2.addObject(link.text!.componentsSeparatedByString(""))
                //dataParse2 += link.text!.componentsSeparatedByString("")
                //dataParse2.insertObject(link.text!.componentsSeparatedByString(""), atIndex: 1)
            }
            print("DATA =", dataParse2)
            //print("DATA =", dataParse2)
            
            self.dataList = dataParse
            //self.dataList2 = dataParse2
            //self.tableView.reloadData()

//            for link in doc.xpath("//td[@class='column-2']/a/@href") {
//                print(link.text)
//                //print(link["a href"])
//            }
        }
        
        
    }
    
    func reloadDataList(){
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            return
        }
    }


}

