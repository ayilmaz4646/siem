//
//  ViewController.swift
//  tkanna
//
//  Created by Ahmet Yilmaz on 18/06/16.
//  Copyright © 2016 Ahmet Yilmaz. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var tbl_line = [item]()
    var tbl_line_s = [String]()
    var tbl_line_filtered = [String]()
    var searchBarActive:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        htmlParserWithKanna("http://www.elreha.de/technische-handbucher-archiv/")
        print(tbl_line[1].title)
        print("count", tbl_line.count)
        //print("count eski", dataNameList.count)
        print("lang", tbl_line[2].lang[1])
        
        tableView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        
        for (title, _) in tbl_line.enumerate(){
            print("Item \(title): \(tbl_line[title].lang)")
            tbl_line_s.append(tbl_line[title].title)
        }
        print("AAAAAAAAA", tbl_line_s)
        
//        if let found = find(tbl_line.map({ $0; $1.map{ $0.lang == "e" } })) {
//            let obj = tbl_line[found]
//        }
//        
//        let searchText = "d"
//        
//        let filtered = tbl_line.map(
//            ($0, $1.filter {
//                $0.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
//                })
//            };.filter { !isEmpty($1) )
//        
//        print(filtered)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        nav?.tintColor = UIColor.yellowColor()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "elrehaLogo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        return dataNameList.count
        if (searchBarActive){
            return tbl_line_filtered.count
        }
        return tbl_line.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell")! as UITableViewCell
        if (cell.isEqual(NSNull)){
            cell = NSBundle.mainBundle().loadNibNamed("mycell", owner: self, options: nil)[0] as! UITableViewCell
        
        }
        
        if (searchBarActive)
        {
            cell.textLabel?.text = tbl_line_filtered[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = String(tbl_line[indexPath.row].title)
            cell.detailTextLabel?.text = String(tbl_line[indexPath.row].lang)
        }
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell #ssss")
        
        let actionSheet = UIAlertController(title: "", message: "Share your Note", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let openAction = UIAlertAction(title: "Open", style: UIAlertActionStyle.Default) { (action) -> Void in
            let firstActivityItem = UIApplication.sharedApplication().openURL(NSURL(string: String(self.tbl_line[indexPath.row].link))!)
            
            _ = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        }
        
        let downloadAction = UIAlertAction(title: "Download", style: UIAlertActionStyle.Default) { (action) -> Void in
            var localPath: NSURL?
            Alamofire.download(.GET,
                String(self.tbl_line[indexPath.row].link),
                destination: { (temporaryURL, response) in
                    let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                    let pathComponent = response.suggestedFilename
                    localPath = directoryURL.URLByAppendingPathComponent(pathComponent!)
                    return localPath!
                    
                }
                )
                .response { (request, response, _, error) in
                    print(response)
                    print("Downloaded file to \(localPath!)")
            }
        }
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in}
        
        actionSheet.addAction(openAction)
        actionSheet.addAction(downloadAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }

    
    func htmlParserWithKanna(url:String)
    {
        
        if let doc = Kanna.HTML(url: (NSURL(string: url)!), encoding: NSUTF8StringEncoding) {
            for tbl_tr in doc.xpath("//table[@id='tablepress-4']/tbody/tr") {

                let link_label = tbl_tr.css("td:nth-child(1)").text
                let link_url   = tbl_tr.xpath("td[@class='column-2']/a/@href").text
                let link_lang  = tbl_tr.xpath("td/img/@alt").text
                let item_value = item()
                
                if ((link_url) != ""){
                    item_value.title = link_label!
                    item_value.link = link_url!
                    item_value.lang += link_lang!.componentsSeparatedByString("_flag")
                    item_value.lang.removeLast()

                    tbl_line.append(item_value)
                    
                    print("Url Geldiii...")
                    //print(item_value.lang)
//                    dataNameList += link_label!.componentsSeparatedByString("")
//                    dataLinkList += link_url!.componentsSeparatedByString("")
                }
//                print("Geldiii...")
//                print(item_value.title)
                //print(link_url)
                //dataList2.insertObject(link_label!, atIndex: 0)
            }
            
            
//            print("DATA =", dataList2)
            
            //self.dataList.append(dataList2.componentsJoinedByString(""))
        }
        
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBarActive = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        tbl_line_filtered = tbl_line_s.filter({ (text) -> Bool in
            let txt : NSString = text
            let range = txt.rangeOfString(searchText, options: NSStringCompareOptions .CaseInsensitiveSearch)
            
            return range.location != NSNotFound
        })
        if (tbl_line_filtered.count == 0)
        {
            searchBarActive = false
        }
        else
        {
            searchBarActive = true
        }
        
        self.tableView.reloadData()
    }
    
    func reloadDataList(){
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            return
        }
    }
    


class item {
    var title = String()
    var link = String()
    var lang = [String]()
    
}
    
}
