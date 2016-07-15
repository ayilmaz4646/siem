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
    var tbl_line_lang = [String]()
    var searchBarActive:Bool = false
    var listLangActive:Bool = false
    var selectLang = String()

    
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
        
//        for (slang, _) in tbl_line.enumerate(){
//            print("Item \(slang): \(tbl_line[slang].lang)")
//            if (tbl_line[slang].lang).indexOf("nl") != nil {
//                tbl_line_lang.append(tbl_line[slang].title)
//            }
//        }
//        print("LLLLLLLLLL", tbl_line_lang)
        
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
    
    @IBAction func langButton(sender: AnyObject) {
        listLangActive = true
        selectLang = "nl"
        print(listLangActive)
        print(selectLang)
        for (slang, _) in tbl_line.enumerate(){
            print("Item \(slang): \(tbl_line[slang].lang)")
            if (tbl_line[slang].lang).indexOf(selectLang) != nil {
                tbl_line_lang.append(tbl_line[slang].title)
            }
        }
        self.tableView.reloadData()
        print("tbbbb", tbl_line_lang)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (searchBarActive){
            return tbl_line_filtered.count
        }
        else if (listLangActive){
            return tbl_line_lang.count
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
        else if (listLangActive)
        {
            cell.textLabel?.text = tbl_line_lang[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = String(tbl_line[indexPath.row].title)
            cell.detailTextLabel?.text = String(tbl_line[indexPath.row].lang)
        }
        cell.textLabel!.font = UIFont(name:"TimesNewRomanPS-BoldMT ", size:12)
        
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
                    
                }

            }

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
    
}
