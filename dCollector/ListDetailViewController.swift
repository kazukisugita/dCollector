//
//  ListDetailViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/08.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import SafariServices

final class ListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    fileprivate var selfDidAppeared: Bool = false
    @IBOutlet weak var listDetailTableView: UITableView!
    fileprivate let listDetailTableViewContentInset: CGFloat = 24.0
    @IBOutlet weak var listDetailTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: CloseListDetailUIButton!
    @IBOutlet weak var domainInfoView: UIView!
    public let domainInfoViewTopMargin: CGFloat = 24.0
    @IBOutlet weak var domainInfoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var domainIcon: UIImageView?
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    @IBOutlet weak var domainDescription: UILabel!
    
    fileprivate var readyToPullDismiss: Bool = true
    fileprivate var viewPositionY: CGFloat = 0.0
    
    fileprivate var pullToDismiss: PullToDismiss?
    
    @IBAction func closeButtonHandle(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
        pullToDismiss?.start()
    }
    
    var selectedDomain: Domain? {
        didSet {
            configureDomainView()
        }
    }
    var urls: [Url] = []
    
    fileprivate var selfViewPanDirectionY: CGFloat = 0.0
    
    override func loadView() {
        super.loadView()
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Self View
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ListDetailViewController.handlePan(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        // TableView
    
        listDetailTableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        listDetailTableView.delegate = self
        listDetailTableView.dataSource = self
        
        listDetailTableView.rowHeight = 70.0
        listDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        listDetailTableView.separatorColor = UIColor.hexStr(type: .textBlack, alpha: 0.16)
        listDetailTableView.contentInset = UIEdgeInsetsMake(listDetailTableViewContentInset, 0.0, listDetailTableViewContentInset, 0.0)
        setHeightForTableView()
        
        // TableView Cell
        
        let nib: UINib = UINib(nibName: "ListDetailTableViewCell", bundle: nil)
        listDetailTableView.register(nib, forCellReuseIdentifier: "ListDetailTableViewCell")
        
        // Long Press
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ListDetailViewController.longPressHandler))
        longPress.allowableMovement = 400
        longPress.minimumPressDuration = 0.6
        longPress.numberOfTapsRequired = 0
        longPress.numberOfTouchesRequired = 1
        listDetailTableView.addGestureRecognizer(longPress)
        
        // Domain Info View
        
        domainInfoView.isUserInteractionEnabled = true
        let domainInfoViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListDetailViewController.callSafariInHostPage))
        domainInfoView.addGestureRecognizer(domainInfoViewTap)
        domainInfoViewTopConstraint.constant = domainInfoViewTopMargin
        
        // PullToDismiss
        
        pullToDismiss = PullToDismiss(in: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        selfDidAppeared = true
    }
    
    deinit {
        listDetailTableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    func configureDomainView() {
        if let _domain = selectedDomain {
            self.domainTitle?.text = _domain.title
            self.domainHost?.text = _domain.name
            self.domainDescription?.text = _domain.siteDescription
            
            if let image = _domain.icon {
                self.domainIcon?.image = UIImage(data: image as Data)
            } else {
                let i = #imageLiteral(resourceName: "no-image-icon")
                self.domainIcon?.image = i
            }
            
        }
    }
    
    private func setHeightForTableView() {
        
        let top = domainInfoViewTopMargin + domainInfoView.bounds.height
        let bottom = UIScreen.main.bounds.height
        
        listDetailTableViewBottomConstraint.constant = top - bottom
    }
    
    func callSafariInHostPage() {
        let url: Url = Url()
        url.url = "https://" + self.domainHost.text!
        openBrowser(url: url)
    }
    
    func openBrowser(url: Url) {
        
        switch AppSettings.broswerIs() {
            
        case Browsers.dDefault.hashValue:
            let safariViewController = SFSafariViewController(url: URL(string: url.url)!)
            safariViewController.modalPresentationStyle = .popover
            present(safariViewController, animated: true, completion: nil);
            
        case Browsers.safari.hashValue:
            let url: URL = URL(string:"\(url.url)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        case Browsers.chrome.hashValue:
            
            var urlStr = url.url
            
            if let range = url.url.range(of: "http://") {
                urlStr.removeSubrange(range)
            } else if let range = url.url.range(of: "https://") {
                urlStr.removeSubrange(range)
            }
            
            let _url: URL = URL(string:"googlechrome://\(urlStr)")!
            UIApplication.shared.open(_url, options: [:], completionHandler: nil)
            
        default:
            break
        }
    }
    
}

// MARK: ScrollView KeyValueChangeEvent
extension ListDetailViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath != "contentOffset" { return }
        
        guard
            let tableView = object as? UITableView,
            let offset = change![NSKeyValueChangeKey.newKey] as? CGPoint
        else {
            return
        }
        
        updateViewPosition(scrollView: tableView, offset: offset.y)
    }
    
    fileprivate func updateViewPosition(scrollView: UIScrollView, offset: CGFloat) {
        
        if offset >= -(listDetailTableViewContentInset) { return }
        if selfDidAppeared == false { return }
        if readyToPullDismiss == false { return }
        
        let diff = -(offset + listDetailTableViewContentInset)
        viewPositionY += diff
//        UIView.performWithoutAnimation({ () in
//            domainInfoViewTopConstraint.constant += diff
//        })
        pullToDismiss?.onFraction(viewPositionY)
        
        // reset
        scrollView.contentOffset.y = -listDetailTableViewContentInset
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        readyToPullDismiss = scrollView.contentOffset.y == -(listDetailTableViewContentInset)
        
//        if viewPositionY > 0 {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
//            self.dismiss(animated: true, completion: nil)
//        }
        pullToDismiss?.start()
    }
    
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        readyToPullDismiss = scrollView.contentOffset.y == -(listDetailTableViewContentInset)
        
//        if viewPositionY > 0 {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
//            self.dismiss(animated: true, completion: nil)
//        }
        pullToDismiss?.start()
    }
}


// MARK: TableView
extension ListDetailViewController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.urls.count
        return (RealmManager.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false).count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let url = urls[indexPath.row]
        
        var url: Url!
        let sortedUrls = RealmManager.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false)
        url = sortedUrls![indexPath.row]
        
        let cell: ListDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListDetailTableViewCell", for: indexPath) as! ListDetailTableViewCell
        
        cell.urlTitle?.text = url.title
        cell.url?.text = url.url
        
        return cell
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        var url: Url!
        let sortedUrls = RealmManager.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false)
        url = sortedUrls![indexPath.row]
        
        openBrowser(url: url)
    }
}

extension ListDetailViewController {
    
    // Cell
    
    func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {

            let point: CGPoint = sender.location(in: self.listDetailTableView)
            guard let indexPath = self.listDetailTableView.indexPathForRow(at: point) else { return }
            
            callActionSheet(indexPath)
        }
    }
    
    
    func callActionSheet(_ indexPath: IndexPath) {

        guard let domain = RealmManager.getDomainByName(selectedDomain!.name) else { return }
        let sortedUrls = domain.urls.sorted(byKeyPath: "createdAt", ascending: false)
        let url = sortedUrls[indexPath.row].url
        let title = sortedUrls[indexPath.row].title
        
        let actionSheet: UIAlertController = UIAlertController(title: title, message: "Delete this Url.\nAre you Sure ??".localized(), preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "DELETE".localized(), style: .destructive, handler: { (action) in
            
            DispatchQueue.main.async {
                let _url = RealmManager.getUrlWithPrimaryKey(url)
                RealmManager.deleteUrl(url: _url!)
                
                let _domain = RealmManager.getDomainWithPrimaryKey(self.selectedDomain!.name)
                
                self.urls.removeAll()
                
                for url_ in (_domain?.urls)! {
                    self.urls.append(url_)
                }
                
                let table = self.listDetailTableView!
                
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
    
    
}

extension ListDetailViewController {
    
    func handlePan (gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .changed {
            
            let translationY = gestureRecognizer.translation(in: self.view).y

            pullToDismiss?.onFraction(translationY)
            
//            UIView.performWithoutAnimation({ () in
//                domainInfoViewTopConstraint.constant += translationY
//            })
//            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
//
//            selfViewPanDirectionY = translationY
            
        } else if gestureRecognizer.state == .ended {
            
            if (selfViewPanDirectionY > 0) {
                //print("down")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                //print("up")
//                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
//                    self.domainInfoViewTopConstraint.constant = self.domainInfoViewTopMargin
//                    self.view.layoutIfNeeded()
//                }, completion: nil)
                self.pullToDismiss?.start()
            }
        }
        
    }
    
    
}
