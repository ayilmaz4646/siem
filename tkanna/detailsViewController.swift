//
//  detailsViewController.swift
//  tkanna
//
//  Created by Ahmet Yilmaz on 21/06/16.
//  Copyright © 2016 Ahmet Yilmaz. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var ttitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    

    var selectedTitle:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = selectedTitle
        if selectedTitle == "impressum"{
            textView.text = NSLocalizedString("LEGAL NOTICE \n\n ELREHA Elektronische Regelungen GmbH Schwetzinger Str. 103 \n D-68766 Hockenheim \n Tel: (+49) (0)6205-2009-0\n Fax: (+49) (0)6205-2009-39\n E-Mail: sales@elreha.de\n ----------------\n Commercial register of the Local Court of Mannheim \n HRB 420487 \n ----------------\n Managing Director\n A. Hamadeh\n ----------------\n Tax Id \n DE 144 301 436 \n ----------------\n Visit our homepage for more info: \n www.elreha.de", comment: "textview about impressum")
        }
        else if selectedTitle == "aboutelreha"{
            textView.text = NSLocalizedString("ABOUT ELREHA GmbH \n ----------------\n ELREHA (Elektronische Regelungen GmbH) was established in 1976. We are an international leader in development, production and sales of electronic controllers and control systems, for industrial and commercial needs in heating, refrigeration and freezing applications. Our Hockenheim-Germany facility is home to all of our operations, including Sales, Design, Manufacturing, and Distribution. Our global footprint spans across 3 continents, with additional manufacturing and operations in the USA and Jordan, and a sales office in France. Our global network includes partners in Austria, Switzerland and the Netherlands with a total number of 300 employees. We can guarantee the best service for our customers with our widespread global knowledge, capacity, and capabilities. Our entire product portfolio, which ranges from individual customized electrical cabinets, to standardized temperature sensors and controllers, are engineered and manufactured with advanced production technologies in Hockenheim. As an added point of great pride, we also have the unique advantage of producing our own PCBs. Our corporate philosophies drive our services, and innovations to the highest standards in quality and reliability. That is the value that we bring to you.", comment: "textview about elreha")
        }
        else if selectedTitle == "aboutelrehaapp"{
            textView.text = NSLocalizedString("About Elreha Manuals \n Version 1.0 \n ----------------\n ELREHA (Elektronische Regelungen GmbH) was established in 1976. We are an international leader in development, production and sales of electronic controllers and control systems, for industrial and commercial needs in heating, refrigeration and freezing applications. Our entire product portfolio, which ranges from individual customized electrical cabinets, to standardized temperature sensors and controllers, are engineered and manufactured with advanced production technologies in Hockenheim. The ELREHA App. was designed to provide you the ability to download our manuals with the utmost convenience. Try it for yourself!", comment: "textview about elreha app")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "elrehaLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
    }

}
