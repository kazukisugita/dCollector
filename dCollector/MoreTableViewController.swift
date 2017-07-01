//
//  MoreTableViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/25.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var appVersionLabel: UILabel!
    let license = License()
    var titles: [String] {
        return license?.titles ?? []
    }
    
    fileprivate var tappedLicense = (githubText: "", licenseText: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationItem.title = "SETTING & LICENSE"
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            self.appVersionLabel.text = "ver " + version
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "licenseSegue") {
            if let vc: LicenseViewController = segue.destination as? LicenseViewController {
                vc._githubText = tappedLicense.githubText
                vc._licenseText = tappedLicense.licenseText
            }
        }
    }
    
    
    @IBAction func popView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
}


// MARK: - Table view data source
extension MoreTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return titles.count
        } else {
            return 1
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            let wifiSwitch = UISwitch()
            wifiSwitch.isOn = AppSettings.onlyDownloadWithWifi()
            wifiSwitch.addTarget(self, action: #selector(MoreTableViewController.onSwitch), for: UIControlEvents.valueChanged)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.text = "Only Download with WiFi".localized()
            cell.accessoryView = UIView(frame: wifiSwitch.frame)
            cell.accessoryView?.addSubview(wifiSwitch)
        case 1:
            cell.textLabel?.text = titles[indexPath.row]
        default:
            break
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            guard
            let licenseText = license?.getLicenseText(index: indexPath.row),
            let githubText = license?.getGithubText(index: indexPath.row) else { return }
            tappedLicense.githubText = githubText
            tappedLicense.licenseText = licenseText
            performSegue(withIdentifier: "licenseSegue", sender: nil)
        default:
            break
        }
        
        
    }
    
    override func tableView(_ tableview: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "settings"
        }
        return "License"
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.hexStr(type: .textBlack_v2, alpha: 1.0)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
}

extension MoreTableViewController {
    
    func onSwitch(sender: UISwitch) {
        let bool = sender.isOn
        AppSettings.changeBool_onlyDownloadWithWifi(bool)
    }
    
}
