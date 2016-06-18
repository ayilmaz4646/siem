//
//  ViewController.swift
//  tkanna
//
//  Created by Ahmet Yilmaz on 18/06/16.
//  Copyright © 2016 Ahmet Yilmaz. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let html = "<html></html>"
//        let url = ""
//        
//        if let doc = Kanna.HTML(html: html, url: url, encoding: NSUTF8StringEncoding) {
//            print(doc.title)
//            
//            // Search for nodes by CSS
//            for link in doc.css("a, link") {
//                print(link.text)
//                print(link["href"])
//            }
//            
//            // Search for nodes by XPath
//            for link in doc.xpath("//a | //link") {
//                print(link.text)
//                print(link["href"])
//            }
//        }
        
        if let doc = Kanna.HTML(url: (NSURL(string: "http://www.elreha.de/technische-handbucher-archiv/")!), encoding: NSUTF8StringEncoding) {
            
//            <html><head></head><body><table id='tablepress-4'><tbody><tr><td class='column-1'></td></tr></tbody></table></body></html>
            // Search for nodes by XPath
//            for link in doc.xpath("/html/body/section/div/section/article/div[1]/div[2]/div/table/tbody/tr[1]/td[1]") {
            for link in doc.xpath("/html/body") {
                print(link.text)
                print(link["href"])
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

