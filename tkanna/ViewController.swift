//
//  ViewController.swift
//  tkanna
//
//  Created by Ahmet Yilmaz on 18/06/16.
//  Copyright © 2016 Ahmet Yilmaz. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIDocumentInteractionControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

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
    var title_close = NSLocalizedString("Close", comment: "alertController title_close")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(title: "No Internet", message: "You need an internet connection to use this app", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                handler: { ACTION in exit(0)}))
            self.present(alert, animated: true, completion: nil)
            
        }
        htmlParserWithKanna(url: "http://www.elreha.de/technische-handbucher-archiv/")
        pickerViewContainer.isHidden = true
        newPicker.isHidden = true
        
        tableView.delegate = self
        searchBar.delegate = self
//        searchBar.showsCancelButton = true
        tableView.dataSource = self
        newPicker.delegate = self
        newPicker.dataSource = self
        
        for (title, _) in tbl_line.enumerated(){
            language.append("all")
//            language.append("tr")
            language += tbl_line[title].lang
        }
        uniqlang = Array(Set(language)).sorted()
        tbl_temp = tbl_line
        set_language_icon_by_uniqlang()
        changetitleleft(value: "\u{2139}")
        self.tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
//        let blueColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
//        view.backgroundColor = blueColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "elrehaLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        let item = self.navigationItem.leftBarButtonItem
        let button = item!.customView as! UIButton
        button.setTitle("\u{1F30E}", for: .normal)
    }
    
    func imageTapped(img: AnyObject){}
    
    @IBAction func langButton(sender: AnyObject) {
        if listLangPickerActive == true{
            listLangPickerActive = false
            pickerViewContainer.isHidden = false
            newPicker.isHidden = false
        }
        else{
            listLangPickerActive = true
            pickerViewContainer.isHidden = true
            newPicker.isHidden = true
        }
    }
    
    @IBAction func okbutton(sender: AnyObject) {
        pickerViewContainer.isHidden = true
        newPicker.isHidden = true
        listLangPickerActive = true
    }

    @IBAction func segueButton(sender: AnyObject) {
        let actionSheet = UIAlertController()

        let title_ln = NSLocalizedString("Legal Notice ", comment: "alertController title_ln")
        let impAction = UIAlertAction(title: title_ln, style: UIAlertActionStyle.default) { (action) -> Void in
            let text = "impressum"
            self.performSegue(withIdentifier: "segue", sender: text)
        }

        let title_gmbh = NSLocalizedString("About Elreha GmbH", comment: "alertController title_gmbh")
        let aboutAction = UIAlertAction(title: title_gmbh, style: UIAlertActionStyle.default) { (action) -> Void in
            let text = "aboutelreha"
            self.performSegue(withIdentifier: "segue", sender: text)
        }

        let title_app = NSLocalizedString("About Elreha Manuals", comment: "alertController title_app")
        let aboutappAction = UIAlertAction(title: title_app, style: UIAlertActionStyle.default) { (action) -> Void in
            let text = "aboutelrehaapp"
            self.performSegue(withIdentifier: "segue", sender: text)
        }

        let dismissAction = UIAlertAction(title: title_close, style: UIAlertActionStyle.cancel) { (action) -> Void in}

        actionSheet.addAction(impAction)
        actionSheet.addAction(aboutAction)
        actionSheet.addAction(aboutappAction)
        actionSheet.addAction(dismissAction)

        present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let detailsVC = segue.destination as? detailsViewController
            detailsVC?.selectedTitle = sender as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uniqlang.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return language_icon[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchBar.text = ""
        tbl_lang.removeAll()
        tbl_temp.removeAll()
        let selectLang = uniqlang[pickerView.selectedRow(inComponent: 0)]

        if selectLang == "all"
        {
            listLangActive = false
            tbl_temp = tbl_line
        }
//        else if selectLang == "tr"
//        {
//            listLangActive = true
//            tbl_lang.append(tbl_line[143])
//            tbl_temp.append(tbl_line[143])
//        }
        else
        {
            for (slang, _) in tbl_line.enumerated(){
                if (tbl_line[slang].lang).index(of: selectLang) != nil {
                    tbl_lang.append(tbl_line[slang])
                    tbl_temp.append(tbl_line[slang])
                    
                }
            }

            listLangActive = true
        }
        changetitleright(value: language_icon[row])
        
        self.tableView.reloadData()
        

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        if (listLangActive){
            tbl_temp = tbl_lang
        }else{
            tbl_temp = tbl_line
        }
        self.tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty){
            self.tableView.reloadData()
            return
        }
        
        if (listLangActive){
            tbl_temp = tbl_lang.filter {
                $0.title.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        else{
            tbl_temp = tbl_line.filter {
                $0.title.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        self.tableView.reloadData()
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tbl_temp.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")! as UITableViewCell
        if (cell.isEqual(NSNull())){
            cell = Bundle.main.loadNibNamed("mycell", owner: self, options: nil)![0] as! UITableViewCell
        
        }
        cell.textLabel?.text = String(tbl_temp[indexPath.row].title)
        
        cell.textLabel!.font = UIFont(name:"TimesNewRomanPS-BoldMT ", size:12)
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let actionSheet = UIAlertController()
        let title_open = NSLocalizedString("Open", comment: "alertController title_open")
        let openAction = UIAlertAction(title: title_open + "(\(self.tbl_temp[indexPath.row].size))", style: UIAlertActionStyle.default) { (action) -> Void in
            let stringUrl = self.tbl_temp[indexPath.row].link
            let URL = NSURL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            let firstActivityItem = UIApplication.shared.openURL(URL as URL)
            
            
            _ = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        }

        let dismissAction = UIAlertAction(title: title_close, style: UIAlertActionStyle.cancel) { (action) -> Void in}
        
        actionSheet.addAction(openAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController){
        print("dissmissed")

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let blueColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
//        cell.backgroundColor = blueColor
//    }
    
    func htmlParserWithKanna(url:String)
    {
        
        if let doc = Kanna.HTML(url: (NSURL(string: url)! as URL), encoding: String.Encoding.utf8) {
            for tbl_tr in doc.xpath("//table[@id='tablepress-4']/tbody/tr") {

                let link_label = tbl_tr.at_css("td:nth-child(1)")?.text as Any
                let link_url   = tbl_tr.at_xpath("td[@class='column-2']/a/@href")?.text
                let link_lang  = tbl_tr.at_xpath("td/img/@alt")?.text as Any
                let link_size  = tbl_tr.at_xpath("td[@class='column-9']")?.text as Any
                let item_value = item()
                if ((link_url) != nil) {
                    item_value.title = link_label as! String
                    item_value.link = link_url!
                    item_value.size = link_size as! String
                    item_value.lang += (link_lang as AnyObject).components(separatedBy: "_flag")
                    item_value.lang.removeLast()
                    tbl_line.append(item_value)

                }

            }

        }
        
    }
    
    func reloadDataList(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            return
        }
    }
    
    func set_language_icon_by_uniqlang() {
        
        for (_, element) in uniqlang.enumerated() {
            if ("\(element)") == "d"{
                language_icon.append("\u{1f1e9}\u{1f1ea}")
            }else if ("\(element)") == "all"{
                language_icon.append("\u{1F30E}")
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
//            else if ("\(element)") == "tr"{
//                language_icon.append("\u{1F1F9}\u{1F1F7}")
//            }
            else {
                language_icon.append("\(element)")
            }
        }
    }
    
    func changetitleright(value:String) {
        let item = self.navigationItem.leftBarButtonItem
        let button = item!.customView as! UIButton
        button.setTitle(value, for: .normal)
    }
    func changetitleleft(value:String) {
        let item = self.navigationItem.rightBarButtonItem
        let button = item!.customView as! UIButton
        button.setTitle(value, for: .normal)
    }
    
}
