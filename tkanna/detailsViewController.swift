//
//  detailsViewController.swift
//  tkanna
//
//  Created by Ahmet Yilmaz on 21/06/16.
//  Copyright © 2016 Ahmet Yilmaz. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController {

    @IBOutlet weak var ttitle: UILabel!
    var selectedTitle:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if selectedTitle != nil
        {
            self.navigationItem.title = selectedTitle
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
