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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var newPicker: UIPickerView!
    @IBAction func about(sender: AnyObject) {
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var langPicker: UIPickerView!
    @IBOutlet weak var pickerViewContainer: UIView!
    @IBAction func HidePV(sender: AnyObject) {}
    @IBAction func tabButton(sender: AnyObject) {}
    @IBOutlet weak var tableView: UITableView!

    var tbl_line = [item]()
    var tbl_line_s = [String]()
    var tbl_line_filtered = [String]()
    var tbl_line_lang = [String]()
    var language = [String]()
    var uniqlang = [String]()
    var language_icon = [String]()
    var searchBarActive:Bool = false
    var listLangActive:Bool = false
    var listLangPickerActive:Bool = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(title: "No Internet", message: "You need an internet connection to use this app", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: { ACTION in exit(0)}))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        htmlParserWithKanna("http://www.elreha.de/technische-handbucher-archiv/")
        print("count", tbl_line.count)
        //print("count eski", dataNameList.count)
        pickerViewContainer.hidden = true
        newPicker.hidden = true
        
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        tableView.dataSource = self
        newPicker.delegate = self
        newPicker.dataSource = self
        
        for (title, _) in tbl_line.enumerate(){
            print("Item \(title): \(tbl_line[title].lang)")
            language.append("all")
            language += tbl_line[title].lang
        }
        for (title, _) in tbl_line.enumerate(){
            print("Item \(title): \(tbl_line[title].lang)")
            tbl_line_s.append(tbl_line[title].title)
        }
        uniqlang = Array(Set(language)).sort()
        print("AAAAAAAAA", language)
        print("uniq", uniqlang)

        set_language_icon_by_uniqlang()
    }
    
    override func viewDidAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        //nav?.tintColor = UIColor.yellowColor()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "elrehaLogo")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func imageTapped(img: AnyObject){}
    
    @IBAction func langButton(sender: AnyObject) {
        if listLangPickerActive == true{
            listLangPickerActive = false
            pickerViewContainer.hidden = false
            newPicker.hidden = false
        }
        else{
            listLangPickerActive = true
            pickerViewContainer.hidden = true
            newPicker.hidden = true
        }
        print(listLangActive)
    }
    
    @IBAction func segueButton(sender: AnyObject) {
        //self.performSegueWithIdentifier("segue", sender: nil)
        let actionSheet = UIAlertController(title: "", message: "About", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let openAction = UIAlertAction(title: "Impressum", style: UIAlertActionStyle.Default) { (action) -> Void in
            let text = "impressum"
            self.performSegueWithIdentifier("segue", sender: text)
        }
        
        let downloadAction = UIAlertAction(title: "About Elreha GmbH", style: UIAlertActionStyle.Default) { (action) -> Void in
            let text = "aboutelreha"
            self.performSegueWithIdentifier("segue", sender: text)
        }
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in}

        actionSheet.addAction(openAction)
        actionSheet.addAction(downloadAction)
        actionSheet.addAction(dismissAction)

        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue" {
            let detailsVC = segue.destinationViewController as? detailsViewController
            detailsVC?.selectedTitle = sender as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uniqlang.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return language_icon[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tbl_line_lang.removeAll()
        let selectLang = uniqlang[pickerView.selectedRowInComponent(0)]
        print("llll", selectLang)

        if selectLang == "all"
        {
            listLangActive = false
        }
        else
        {
            for (slang, _) in tbl_line.enumerate(){
                //print("Item \(slang): \(tbl_line[slang].lang)")
                if (tbl_line[slang].lang).indexOf(selectLang) != nil {
                    tbl_line_lang.append(tbl_line[slang].title)
                }
            }

            listLangActive = true
        }

        self.tableView.reloadData()
        

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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        searchBarActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBarActive = false
        self.tableView.reloadData()
        
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
        
        searchBarActive = true
        
        self.tableView.reloadData()
    }

    func reloadDataList(){
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            return
        }
    }
    
    func set_language_icon_by_uniqlang() {
        
        for (index, element) in uniqlang.enumerate() {
            if ("\(element)") == "d"{
                language_icon.append("\u{1f1e9}\u{1f1ea}")
            }
            else if ("\(element)") == "e"{
                language_icon.append("\u{1F1EC}\u{1F1E7}")
            }
            else if ("\(element)") == "f"{
                language_icon.append("\u{1F1EB}\u{1F1F7}")
            }
            else if ("\(element)") == "nl"{
                language_icon.append("\u{1F1F3}\u{1F1F1}")
            }
            else if ("\(element)") == "pl"{
                language_icon.append("\u{1F1F5}\u{1F1F1}")
            }
            else if ("\(element)") == "r"{
                language_icon.append("\u{1F1F7}\u{1F1FA}")
            }
            else {
                language_icon.append("\(element)")
            }
        }
    }
    
}
