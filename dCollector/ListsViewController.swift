//
//  ListsViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/07.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit


final class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listsTableView: UITableView!
    //fileprivate var editButton: UIBarButtonItem?
    
    //var listRefresher: UIRefreshControl!
    
    var selectedDomain: Domain!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var textInLoadingView: UILabel!
    @IBOutlet weak var successUrlInLoadingView: UILabel!
    @IBOutlet weak var loadingBlurView: UIVisualEffectView!
    
    @IBOutlet weak var extensionGuid: UIImageView!
    @IBOutlet weak var guidLabel: UILabel!
    
    fileprivate var isLoading: Bool = false
    var userdefaults: Array<String>?
    
    let modalTransitionDelegate = ModalTransitionDelegate()
    
    override func loadView() {
        super.loadView()
        
        // TableView Cell
        let nib: UINib = UINib(nibName: "ListsTableViewCell", bundle: nil)
        listsTableView.register(nib, forCellReuseIdentifier: "ListsTableViewCell")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let _ = iCloudManager()
        
        // Self View
        
        //let titleImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        //titleImageView.image = #imageLiteral(resourceName: "tabbar-icon-lists")
        //self.navigationItem.titleView = titleImageView
        self.navigationItem.title = "Domains"
        
        // TableView
        
        listsTableView.delegate = self
        listsTableView.dataSource = self
        
        listsTableView.rowHeight = 60.0
        listsTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        listsTableView.separatorColor = UIColor.hexStr(type: .textBlack, alpha: 0.16)
        //let barHeight = self.navigationController!.navigationBar.bounds.height
        //listsTableView.contentInset = UIEdgeInsetsMake((barHeight-1.0), 0.0, 0.0, 0.0)
        listsTableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTable), name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
        
        //self.editButton = UIBarButtonItem(title: "edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.selToEdit))
        //self.navigationItem.leftBarButtonItem = self.editButton
        
        // TableView Refresh
        
        //listRefresher = UIRefreshControl()
        //listRefresher.attributedTitle = NSAttributedString(string: "")
        //listRefresher.addTarget(self, action: #selector(ListsViewController.refreshTable), for: UIControlEvents.valueChanged)
        
        //listsTableView.refreshControl = listRefresher
        
        // Loading View & loagind Blur View
        configureLoadingView()
        
        // ExtensionGuid
        extensionGuid.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        // GuidLabel
        guidLabel.text = "Collect URL from Safari !!".localized()
        guidLabel.isHidden = true
        
        // Long Press
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ListsViewController.longPressHandler))
        longPress.allowableMovement = 400
        longPress.minimumPressDuration = 0.6
        longPress.numberOfTapsRequired = 0
        longPress.numberOfTouchesRequired = 1
        listsTableView.addGestureRecognizer(longPress)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //refreshTable()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //print("failUrls: \(appDelegate.transactionFailUrls)")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //print(" --- ListsViewController viewWillAppear --- ")
        super.viewWillAppear(animated)
        refreshTable()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //print(" --- ListsViewController viewWillDisappear --- ")
        super.viewWillDisappear(true)
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
            //self.extensionGuid.isHidden = false
            extensinGuidVisible(is: true)
        } else {
            //self.extensionGuid.isHidden = true
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
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let listsDetailVC = sb.instantiateViewController(withIdentifier: "ListDetailView") as! ListDetailViewController
        
        transitioningDelegate = modalTransitionDelegate
        listsDetailVC.transitioningDelegate = modalTransitionDelegate
        listsDetailVC.modalPresentationStyle = .custom
        
        navigationController?.present(listsDetailVC, animated: true, completion: nil)
        listsDetailVC.selectedDomain = RealmManager.getAllDomain()[indexPath.row]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "toListDetailFromLists") {
            
            if let vc: ListDetailViewController = segue.destination as? ListDetailViewController {
                vc.selectedDomain = self.selectedDomain
            } else {
                print("segue fail")
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        //print("didHighlightRowAt")
    }
    
    func refreshTable() {
        
        if AppSettings.onlyDownloadWithWifi() {
            if AppSettings.isWifiConnection() == false {
                return
            }
        }
        
        if (self.isLoading) {
            return
        } else {
            self.isLoading = true
        }
        
        //self.listRefresher.beginRefreshing()
        
        self.view.setNeedsLayout()
        
        var defaultsCount: Int
        
        if let _defaults = AppGroup.tryReturnUserDefaults() {
            defaultsCount = _defaults.count
            self.textInLoadingView.text = "0 / \(defaultsCount)"
            self.successUrlInLoadingView.text = "LOADING...".localized()
        } else {
            self.listsTableView.reloadData()
            //self.listRefresher.endRefreshing()
            self.isLoading = false
            return
        }
        
        var counter: Int = 0
        
        print(" --- refreshTable() --- ")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadingViewVisible(is: true)
        self.extensionGuid.isHidden = true
        
        
        Transaction.fromUserdefaultsToRealm { (complete: Bool, url: String?) in
        
            if let url = url {
                AppGroup.deleteUserDefaultsOneByOne(url: url)
                //print(AppGroup.tryReturnUserDefaults()!)
            }
            
            if complete {
                DispatchQueue.main.async {
                    print("Transaction.fromUserdefaultsToRealm [ FINISHED ]")
                    counter += 1
                    self.textInLoadingView.text = "\(counter) / \(defaultsCount)"
                    
//                    if let _ = url {
//                        self.successUrlInLoadingView.alpha = 0.0
//                        UIView.animate(withDuration: 0.2, animations: {
//                            self.successUrlInLoadingView.text = "OK: \(url_)"
//                            self.successUrlInLoadingView.alpha = 1.0
//                        })
//                    }
                    
                    if defaultsCount == counter {
                        print(" --- --- --- --- --- --- --- --- ")
                        AppGroup.deleteUserDefaultsData()
                        
                        self.listsTableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.isLoading = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.loadingViewVisible(is: false)
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print(" --- tableView didEndDisplaying --- ")
    }

    
}

//MARK: Cell

extension ListsViewController {
    
    func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            let point: CGPoint = sender.location(in: self.listsTableView)
            let indexPath = self.listsTableView.indexPathForRow(at: point)
            
            if let _ = indexPath {
                //print(indexPath!)
                callActionSheet(indexPath!)
            }
        }
    }
    
    
    func callActionSheet(_ indexPath: IndexPath) {
        
        let domain = RealmManager.getAllDomain()[indexPath.row]
        
        let actionSheet: UIAlertController = UIAlertController(title: domain.name, message: "Delete the selected Domain's All Urls.\nAre you Sure ??".localized(), preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "DELETE".localized(), style: .destructive, handler: { (action: UIAlertAction!) in
            
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

        let cancel = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
        })
        
        actionSheet.addAction(ok)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        //return UITableViewCellEditingStyle.delete
        return UITableViewCellEditingStyle.none
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            callActionSheet(indexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("willDisplay: \(indexPath)")
    }
    
    
}

extension ListsViewController {
    
    // FailUrlsView
    
    
}

// MARK: loadingView & extensinGuidView
extension ListsViewController {
    
    func configureLoadingView() {
        loadingView.alpha = 0.0
        self.loadingView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        loadingView.layer.cornerRadius = 4
        loadingView.layer.masksToBounds = false
        loadingView.layer.shadowColor = UIColor.black.cgColor
        loadingView.layer.shadowOpacity = 0.1
        loadingView.layer.shadowOffset = CGSize(width: 0, height: 0)
        loadingView.layer.shadowRadius = 6
        let shadowPath = UIBezierPath(roundedRect: loadingView.bounds, cornerRadius: 10)
        loadingView.layer.shadowPath = shadowPath.cgPath
        /*
        let timing = UICubicTimingParameters(animationCurve: .linear)
        self.loadingViewAnimator = UIViewPropertyAnimator(duration: 2.0, timingParameters: timing)
        self.loadingViewAnimator.addAnimations {
            self.loadingView.center.y += 100
        }
        self.loadingViewAnimator.startAnimation()
        */
        /*
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .curveEaseInOut, .repeat], animations: {
            self.loadingView.alpha = 0.0
        })
        */
        
        //loadingBlurView.alpha = 0.0
        loadingBlurView.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
    }
    
    
    func loadingViewVisible(is bool: Bool) {
        
        if (bool) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            self.loadingView.isHidden = false
            self.textInLoadingView.isHidden = false
            self.loadingBlurView.isHidden = false
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
                self.loadingView.center.y -= 64
                self.loadingView.alpha = 1.0
                self.loadingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                //self.loadingBlurView.alpha = 1.0
            })
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
                self.loadingView.alpha = 0.0
                self.loadingView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
                //self.loadingBlurView.alpha = 0.0
            }, completion: { _ in
                self.loadingView.isHidden = true
                self.textInLoadingView.isHidden = true
                self.loadingBlurView.isHidden = true
            })
        }
        
    }
    
    
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

