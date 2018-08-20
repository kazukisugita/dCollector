
import UIKit
import SnapKit

class SettingTableViewController: UITableViewController {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
//            self.appVersionLabel.text = "ver " + version
        }
        
        initUIs()
        initLayout()
    }
    
    private func initUIs() {
        
        self.navigationItem.title = "Settings".localized()
        
        self.tableView.register(UINib(nibName: "SettingBrowserSwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingBrowserSwitchTableViewCell")
    }
    
    private func initLayout() {
        
    }
    
}

// MARK: TableView

extension SettingTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        cell = indexPath.row == 1 ? tableView.dequeueReusableCell(withIdentifier: "SettingBrowserSwitchTableViewCell") : UITableViewCell()
        
        if indexPath.row == 0 {
            let wifiSwitch = UISwitch()
            wifiSwitch.isOn = AppSettings.onlyDownloadWithWifi()
            wifiSwitch.addTarget(self, action: #selector(onSwitch), for: UIControlEvents.valueChanged)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.text = "Only Download with WiFi".localized()
            cell.accessoryView = UIView(frame: wifiSwitch.frame)
            cell.accessoryView?.addSubview(wifiSwitch)
        }
        
        if indexPath.row == 1 {
            cell.selectionStyle = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            return 88.0
        }
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SettingTableViewController {
    
    @objc func onSwitch(sender: UISwitch) {
        let bool = sender.isOn
        AppSettings.changeBool_onlyDownloadWithWifi(bool)
    }
    
}
