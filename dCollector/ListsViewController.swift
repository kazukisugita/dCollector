
import UIKit
import SnapKit
import SVProgressHUD

final class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var selectedDomain: Domain!
    
    private var listsTableView: UITableView!
    private var extensionGuid: UIImageView!
    private var guidLabel: UILabel!
    
    fileprivate var isLoading: Bool = false
    let modalTransitionDelegate = ModalTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIs()
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTable()
    }
    
    private func initUIs() {
        
        self.navigationItem.title = "Domains"
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshTable),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "ic-setting"), style: .plain, target: self, action: #selector(rightBarButtonItem(onTap:)))
        rightItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightItem
        
        listsTableView = UITableView(frame: .zero, style: .grouped)
        listsTableView.delegate = self
        listsTableView.dataSource = self
        listsTableView.rowHeight = 60.0
        listsTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        listsTableView.separatorColor = UIColor.hexStr(type: .textBlack, alpha: 0.16)
        listsTableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0)
        listsTableView.register(UINib(nibName: "ListsTableViewCell", bundle: nil), forCellReuseIdentifier: "ListsTableViewCell")
        // Long Press
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPress.allowableMovement = 400
        longPress.minimumPressDuration = 0.6
        longPress.numberOfTapsRequired = 0
        longPress.numberOfTouchesRequired = 1
        listsTableView.addGestureRecognizer(longPress)
        self.view.addSubview(listsTableView)
        
        extensionGuid = UIImageView(image: UIImage(named: "extensionGuid"))
        extensionGuid.contentMode = .scaleAspectFit
        extensionGuid.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.view.addSubview(extensionGuid)
        
        guidLabel = UILabel()
        guidLabel.text = "Collect URL from Safari !!".localized()
        guidLabel.isHidden = true
        self.view.addSubview(guidLabel)
    }
    
    private func initLayout() {
        
        listsTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(0.0)
            make.right.equalTo(self.view.snp.right).offset(0.0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0.0)
            make.left.equalTo(self.view.snp.left).offset(0.0)
        }
        
        extensionGuid.snp.makeConstraints { make in
            make.width.equalTo(self.view.snp.width).offset(0.0)
            make.centerX.equalTo(self.view.snp.centerX).offset(0.0)
            make.centerY.equalTo(self.view.snp.centerY).offset(0.0)
        }
        
        guidLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX).offset(0.0)
            make.centerY.equalTo(self.view.snp.centerY).offset(-100.0)
        }
    }
    
    @objc func rightBarButtonItem(onTap sendor: Any) {
        
        let settingTableViewController = SettingTableViewController(style: .grouped)
        self.navigationController?.pushViewController(settingTableViewController, animated: true)
    }
    
}


//MARK: Table View

extension ListsViewController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let counts = RealmManager.getAllDomain().count
        if counts == 0 {
            extensinGuidVisible(is: true)
        } else {
            extensinGuidVisible(is: false)
        }
        return counts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ListsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListsTableViewCell", for: indexPath) as! ListsTableViewCell

        let domain = RealmManager.getAllDomain()[indexPath.row]
        
        if domain.icon == nil && isLoading == false {
            if let iconPath = domain.iconPath {
                Transaction.getIconImage(forCell: cell, iconPath: iconPath, hostName: domain.name)
            }
        }
        
        if domain.icon != nil {
            cell.domainIcon?.image = UIImage(data: domain.icon! as Data)
            cell.domainIcon?.backgroundColor = .none
        }
        
        cell.domainTitle.text = domain.title
        cell.domainHost.text = domain.name
        
        if domain.urls.count < 100 {
            cell.domainCount.text = String(domain.urls.count)
        } else {
            cell.domainCount.text = "99+"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let listsDetailVC = sb.instantiateViewController(withIdentifier: "ListDetailView") as! ListDetailViewController
        
        transitioningDelegate = modalTransitionDelegate
        listsDetailVC.transitioningDelegate = modalTransitionDelegate
        listsDetailVC.modalPresentationStyle = .custom
        
        navigationController?.present(listsDetailVC, animated: true)
        listsDetailVC.selectedDomain = RealmManager.getAllDomain()[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func refreshTable() {
        
        if AppSettings.onlyDownloadWithWifi() {
            if AppSettings.isWifiConnection() == false {
                return
            }
        }
        
        if (self.isLoading) {
            return
        }
        self.isLoading = true
        
        var urlsCount: Int
        
        if let urls = AppGroup.getUrlsFromUserDefaults() {
            SVProgressHUD.setStatus("0 / \(urls.count)")
            urlsCount = urls.count
        } else {
            self.listsTableView.reloadData()
            self.isLoading = false
            return
        }
        
        
        var counter: Int = 0
        
        SVProgressHUD.show()

        self.extensionGuid.isHidden = true
        
        Transaction.fromUserdefaultsToRealm { complete, url in
        
            if let url = url {
                AppGroup.deleteUserDefaultsOneByOne(url: url)
            }
            
            if complete { DispatchQueue.main.async {
                    
                counter += 1
                SVProgressHUD.setStatus("\(counter) / \(urlsCount)")
                
                if urlsCount == counter {
                    AppGroup.deleteUserDefaultsData()
                    
                    self.listsTableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.isLoading = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        SVProgressHUD.dismiss()
                    }
                }
            }}
            
        }
        
    }
    
}

//MARK: Cell

extension ListsViewController {
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            let point: CGPoint = sender.location(in: self.listsTableView)
            let indexPath = self.listsTableView.indexPathForRow(at: point)
            
            if let _ = indexPath {
                callActionSheet(indexPath!)
            }
        }
    }
    
    
    func callActionSheet(_ indexPath: IndexPath) {
        
        let domain = RealmManager.getAllDomain()[indexPath.row]
        
        let actionSheet: UIAlertController = UIAlertController(title: domain.name, message: "Delete the selected Domain's All Urls.\nAre you Sure ??".localized(), preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "DELETE".localized(), style: .destructive, handler: { _ in
            
            DispatchQueue.main.async {
                let domain = RealmManager.getAllDomain()[indexPath.row]
                RealmManager.deleteDomain(domain: domain)
                
                let table = self.listsTableView!
                
                table.beginUpdates()
                table.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                table.perform(#selector(table.reloadData), with: nil, afterDelay: 0.3)
                table.layoutIfNeeded()
                table.endUpdates()
            }
        })
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        actionSheet.addAction(ok)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}


// MARK: extensinGuidView

extension ListsViewController {
    
    func extensinGuidVisible(is bool: Bool) {
     
        if (bool) {
            self.extensionGuid.isHidden = false
            self.guidLabel.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
                self.extensionGuid.alpha = 1.0
                self.extensionGuid.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else {
            self.extensionGuid.isHidden = true
            self.guidLabel.isHidden = true
            self.extensionGuid.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        
    }
    
}

