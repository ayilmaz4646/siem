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
            textView.text = "Impressum \n ELREHA Elektronische regelungen GmbH Schwetzinger Str. 103 \n D-68766 Hockenheim \n\n" +
                "Tel: (+49) (0)6205-2009-0\n" +
                "Fax: (+49) (0)6205-2009-39\n" +
                "Email: sales@elreha.de\n" + "----------------\n" +
                "Handelsregister beim Amtsgericht \n Mannheim\n HRB 420487 \n" + "----------------\n" +
                "gesch\u{00E4}ftsf\u{00FC}hrer\n A. Hamadeh\n" + "----------------\n" +
                "Umsatzsteuer Id-Nr. gem. 27a\n DE 144 301 436 \n" + "----------------\n" +
                "Visit our homepage for more info \n" +
            "www.elreha.de"
        }
        else if selectedTitle == "aboutelreha"{
            textView.text = "About Elreha GmbH \n" + "----------------\n" +
                "Die ELREHA Elektronische Regelungen GmbH hat sich seit ihrer Gr\u{00FC}ndung im jahre 1976" +
            "zu einem der f\u{00FC}hrenden Spezialisten und Hersteller f\u{00FC}r elektronische Regelungs- und Steuerungssysteme f\u{00FC}r die K\u{00E4}lte- und Klimatechnic entwickelt. \n Mit unseren Standorten in Hockenheim (ca. 100 Mitarbeiter) sowie in den USA, Frankreich und Jordainen und unseren Kooperationspartnern in \u{00D6}sterreich, der schweiz und den Niederlanden bilden wir ein globales Unternehmensnetzwerk mit mehr als 300 Mitarbeitern. \n s\u{00E4}mtliche Produkte, vom individuellen Schaltschrank bis hin zu Standartprodukten, wie Temperaturregler und -f\u{00FC}hler werden in unserem werk in Hockenheim mit modernsten Methoden und Maschinen entwickelt und produziert. \n Eine eigene Leiterplattenproduktion ist der Grundstein f\u{00FC}r technisch hochmoderne und zuverl\u{00E4}ssige Produkte. Unsere Kunden profitieren vom Know-how unseres globalen Netzwerkes. unser Anspruch ist es, durch individuelle Serviceleistungen, innovative Produkte, h\u{00F6}chste Zuverl\u{00E4}ssikeit und h\u{00F6}chsten Qualit\u{00E4}tsanspruch unsere Kunden zu begeistern. Dies stellen wir durch unser geschultes Personal und der regelm\u{00E4}\u{00DF}igen Zertifizierung der betrieblichen Alb\u{00E4}ufe nach DIN EN ISO 9001:2008 sicher.\n Wir sind Ihr kompetenter und zeverl\u{00E4}ssiger Partner in allen Belangen im Bereich K\u{00E4}lte- und Klimatechnik."
        }
        else if selectedTitle == "aboutelrehaapp"{
            textView.text = "ELREHA App \n version 1.0 \n" + "----------------\n" +
                "Die ELREHA Elektronische Regelungen Gmbh hat sich seit ihrer Gr\u{00FC}ndung im Jahre 1976 zu einem der f\u{00FC}hrenden Spezialisten und Hersteller f\u{00FC}r elektronische Regelungs- und Steuerungssysteme f\u{00FC}r die K\u{00E4}lte- und Klimatechnik entwickelt. S\u{00E4}mtliche Produkte, vom individuellen Schaltschrank bis hin zu Standardprodukten, wie Temperaturregler und - f\u{00FC}hler werden in unserem Werk in Hockenheim mit modernsten Methoden und Maschinen entwickelt und produziert. Mit dieser App bieten wir Ihnen die Mölichkeit, unsere Bedienungsanleitungen bequem runterzuladen. Probieren Sie es aus!"
        }
        
        //detailLabel.text = selectedTitle
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
//        if selectedTitle != nil
//        {
//            self.navigationItem.title = selectedTitle
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //navigationItem.titleView = UIImageView(image: UIImage(named: "elrehaLogo")!)
        //        navigationController?.navigationItem.titleView = UIImageView(image: UIImage(named: "elrehaLogo")!)
        //        navigationItem.titleView = UIImageView(image: UIImage(named: "elrehaLogo")!)
        //
        //        navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"elrehaLogo"]];
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Default
        //nav?.tintColor = UIColor.yellowColor()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "elrehaLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        //        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        //        imageView.userInteractionEnabled = true
        //        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
