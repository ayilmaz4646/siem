//
//  ViewController.swift
//  tkanna
//
//  Created by Ahmet Yilmaz on 18/06/16.
//  Copyright © 2016 Ahmet Yilmaz. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIDocumentInteractionControllerDelegate {

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
    var tbl_temp = [item]()
    var tbl_lang = [item]()
    var language = [String]()
    var uniqlang = [String]()
    var language_icon = [String]()
    var searchBarActive:Bool = false
    var listLangActive:Bool = false
    var listLangPickerActive:Bool = true
    var docController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(title: "No Internet", message: "You need an internet connection to use this app", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: { ACTION in exit(0)}))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        htmlParserWithKanna("http://www.elreha.de/technische-handbucher-archiv/")
        pickerViewContainer.hidden = true
        newPicker.hidden = true
        
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        tableView.dataSource = self
        newPicker.delegate = self
        newPicker.dataSource = self
        
        for (title, _) in tbl_line.enumerate(){
            language.append("all")
            language += tbl_line[title].lang
        }
        uniqlang = Array(Set(language)).sort()
        tbl_temp = tbl_line
        set_language_icon_by_uniqlang()
    }
    
    override func viewDidAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
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
    }
    
    @IBAction func segueButton(sender: AnyObject) {
        let actionSheet = UIAlertController()
        let impAction = UIAlertAction(title: "Impressum", style: UIAlertActionStyle.Default) { (action) -> Void in
            let text = "impressum"
            self.performSegueWithIdentifier("segue", sender: text)
        }
        
        let aboutAction = UIAlertAction(title: "About Elreha GmbH", style: UIAlertActionStyle.Default) { (action) -> Void in
            let text = "aboutelreha"
            self.performSegueWithIdentifier("segue", sender: text)
        }
        let aboutappAction = UIAlertAction(title: "About Elreha App", style: UIAlertActionStyle.Default) { (action) -> Void in
            let text = "aboutelrehaapp"
            self.performSegueWithIdentifier("segue", sender: text)
        }
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in}

        actionSheet.addAction(impAction)
        actionSheet.addAction(aboutAction)
        actionSheet.addAction(aboutappAction)
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
        searchBar.text = ""
        tbl_lang.removeAll()
        tbl_temp.removeAll()
        let selectLang = uniqlang[pickerView.selectedRowInComponent(0)]

        if selectLang == "all"
        {
            listLangActive = false
            tbl_temp = tbl_line
        }
        else
        {
            for (slang, _) in tbl_line.enumerate(){
                if (tbl_line[slang].lang).indexOf(selectLang) != nil {
                    tbl_lang.append(tbl_line[slang])
                    tbl_temp.append(tbl_line[slang])
                }
            }
            
            listLangActive = true
        }
        
        self.tableView.reloadData()
        

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        if (listLangActive){
            tbl_temp = tbl_lang
        }else{
            tbl_temp = tbl_line
        }
        self.tableView.reloadData()
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty){
            self.tableView.reloadData()
            return
        }
        
        if (listLangActive){
            tbl_temp = tbl_lang.filter {
                $0.title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
        }
        else{
            tbl_temp = tbl_line.filter {
                $0.title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
        }
        
        self.tableView.reloadData()
    }

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tbl_temp.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell")! as UITableViewCell
        if (cell.isEqual(NSNull)){
            cell = NSBundle.mainBundle().loadNibNamed("mycell", owner: self, options: nil)[0] as! UITableViewCell
        
        }
        cell.textLabel?.text = String(tbl_temp[indexPath.row].title)
        
        cell.textLabel!.font = UIFont(name:"TimesNewRomanPS-BoldMT ", size:12)
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell #ssss")
        
        let actionSheet = UIAlertController()
        
        let openAction = UIAlertAction(title: "Open (\(self.tbl_temp[indexPath.row].size))", style: UIAlertActionStyle.Default) { (action) -> Void in
            let firstActivityItem = UIApplication.sharedApplication().openURL(NSURL(string: String(self.tbl_temp[indexPath.row].link))!)
            
            _ = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        }
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in}
        
        actionSheet.addAction(openAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }

    func documentInteractionControllerDidDismissOpenInMenu(controller: UIDocumentInteractionController){
        print("dissmissed")

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
                let link_size  = tbl_tr.xpath("td[@class='column-9']").text
                let item_value = item()
                if ((link_url) != ""){
                    item_value.title = link_label!
                    item_value.link = link_url!
                    item_value.size = link_size!
                    item_value.lang += link_lang!.componentsSeparatedByString("_flag")
                    item_value.lang.removeLast()

                    tbl_line.append(item_value)
                    
                }

            }

        }
        
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
