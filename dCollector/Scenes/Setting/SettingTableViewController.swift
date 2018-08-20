
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
        
        initUIs()
    }
    
    private func initUIs() {
        
        self.navigationItem.title = "Settings".localized()
        
        self.tableView.register(UINib(nibName: "SettingBrowserSwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingBrowserSwitchTableViewCell")
        
        let footerView = UIView()
        footerView.frame.size = CGSize(width: self.view.frame.width, height: 80.0)
        let versionLabel = UILabel()
        versionLabel.frame.size = CGSize(width: self.view.frame.width, height: 20.0)
        versionLabel.textColor = .gray
        versionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            versionLabel.text = "ver " + version
        }
        footerView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(footerView.snp.centerX).offset(0.0)
            make.centerY.equalTo(footerView.snp.centerY).offset(-5.0)
        }
        self.tableView.tableFooterView = footerView
    }
    
    @objc func onSwitch(sender: UISwitch) {
        let bool = sender.isOn
        AppSettings.changeBool_onlyDownloadWithWifi(bool)
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
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            let wifiSwitch = UISwitch()
            wifiSwitch.isOn = AppSettings.onlyDownloadWithWifi()
            wifiSwitch.addTarget(self, action: #selector(onSwitch), for: UIControlEvents.valueChanged)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.text = "Only Download with WiFi".localized()
            cell.accessoryView = UIView(frame: wifiSwitch.frame)
            cell.accessoryView?.addSubview(wifiSwitch)
        }

        return cell
    }
    
}

// MARK: TableView Design

extension SettingTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            return 88.0
        }
        return tableView.rowHeight
    }
    
}
