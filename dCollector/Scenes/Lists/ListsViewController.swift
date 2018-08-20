
import UIKit
import SnapKit
import SVProgressHUD
import Reachability

final class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var selectedDomain: Domain!
    
    private var listsTableView: UITableView!
    private var extensionGuid: UIImageView!
    private var guidLabel: UILabel!
    
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
                                               selector: #selector(handleDidBecomeActive),
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
        self.view.addSubview(extensionGuid)
        
        guidLabel = UILabel()
        guidLabel.text = "Collect URL from Safari !!".localized()
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
    
    @objc func handleDidBecomeActive() {
        
        if AppSettings.onlyDownloadWithWifi() == true && Reachability()?.connection == .cellular { return }
        refreshTable()
    }
    
}


//MARK: Table View

extension ListsViewController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let counts = RealmService.getAllDomain().count
        if counts == 0 {
            extensinGuid(isVisible: true)
        } else {
            extensinGuid(isVisible: false)
        }
        return counts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ListsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListsTableViewCell", for: indexPath) as! ListsTableViewCell

        let domain = RealmService.getAllDomain()[indexPath.row]
        
        if domain.icon == nil {
            if let iconPath = domain.iconPath {
                TransactionService.getIconImage(forCell: cell, iconPath: iconPath, hostName: domain.name)
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
        
        let sb = UIStoryboard(name: "ListDetailViewController", bundle: nil)
        guard let listDetailViewController = sb.instantiateViewController(withIdentifier: "ListDetailViewController") as? ListDetailViewController else {
            fatalError()
        }

        transitioningDelegate = modalTransitionDelegate
        listDetailViewController.transitioningDelegate = modalTransitionDelegate
        listDetailViewController.modalPresentationStyle = .custom
        
        self.present(listDetailViewController, animated: true)
        listDetailViewController.selectedDomain = RealmService.getAllDomain()[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func refreshTable() {
    
        if let presenting = presentingViewController {
            presenting.dismiss(animated: true)
        }
        
        guard let urls = AppGroup.getUrlsFromUserDefaults() else {
            self.listsTableView.reloadData()
            return
        }
        
        SVProgressHUD.show(withStatus: "0 / \(urls.count)")
        var counter: Int = 0
        
        TransactionService.fromUserdefaultsToRealm { complete, url in
        
            if let url = url {
                AppGroup.deleteUserDefaultsOneByOne(url: url)
            }
            
            if complete { DispatchQueue.main.async {
                    
                counter += 1
                SVProgressHUD.setStatus("\(counter) / \(urls.count)")
                
                if urls.count == counter {
                    AppGroup.deleteUserDefaultsData()
                    self.listsTableView.reloadData()
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
        
        let domain = RealmService.getAllDomain()[indexPath.row]
        
        let actionSheet = UIAlertController(title: domain.name, message: "Delete the selected Domain's All Urls.\nAre you Sure ??".localized(), preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "DELETE".localized(), style: .destructive, handler: { _ in
            
            DispatchQueue.main.async {
                let domain = RealmService.getAllDomain()[indexPath.row]
                RealmService.deleteDomain(domain: domain)
                
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
    
    func extensinGuid(isVisible visible: Bool) {
        
        if visible {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
                self.extensionGuid.alpha = 1.0
                self.guidLabel.alpha = 1.0
                self.extensionGuid.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        } else {
            self.extensionGuid.alpha = 0.0
            self.extensionGuid.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.guidLabel.alpha = 0.0
        }
        
    }
    
}

