//
//  LicenseViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/25.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var licenseText: UITextView!
    @IBOutlet weak var githubText: UILabel!
    
    open var _githubText: String!
    open var _licenseText: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.licenseText?.text = _licenseText
        self.githubText?.text = _githubText

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
