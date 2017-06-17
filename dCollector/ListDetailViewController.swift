//
//  ListDetailViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/08.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import SafariServices

class ListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var listDetailTableView: UITableView!
    @IBOutlet weak var domainInfoView: UIView!
    @IBOutlet weak var domainIcon: UIImageView?
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    @IBOutlet weak var domainDescription: UILabel!
    
    var selectedDomain: Domain? {
        didSet {
            configureDomainView()
        }
    }
    var urls: [Url] = []
    
    fileprivate var selfViewPanDirectionY: CGFloat = 0.0
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Self View
        
        //self.title = "Urls"
//        self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.view.alpha = 1.0
        
        //let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ListDetailViewController.handlePan(gestureRecognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ListDetailViewController.handlePan(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        
        // TableView
    
        listDetailTableView.delegate = self
        listDetailTableView.dataSource = self
        
        listDetailTableView.rowHeight = 70.0
        listDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        listDetailTableView.separatorColor = UIColor.hexStr(type: .textBlack, alpha: 0.16)
        listDetailTableView.contentInset = UIEdgeInsetsMake(24.0, 0.0, 24.0, 0.0)
        /*
        listDetailTableView.clipsToBounds = false
        listDetailTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        listDetailTableView.layer.shadowColor = UIColor.gray.cgColor
        listDetailTableView.layer.shadowRadius = 16
        listDetailTableView.layer.shadowOpacity = 0.8
        */
        
        
        // TableView Cell
        
        let nib: UINib = UINib(nibName: "ListDetailTableViewCell", bundle: nil)
        listDetailTableView.register(nib, forCellReuseIdentifier: "ListDetailTableViewCell")
        /*
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
        */
        // Long Press
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ListDetailViewController.longPressHandler))
        longPress.allowableMovement = 400
        longPress.minimumPressDuration = 0.6
        longPress.numberOfTapsRequired = 0
        longPress.numberOfTouchesRequired = 1
        listDetailTableView.addGestureRecognizer(longPress)
        
        
        // Swipe Down
        
        //let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ListDetailViewController.swipeDownAction))
        //swipeDown.numberOfTouchesRequired = 1
        //swipeDown.direction = UISwipeGestureRecognizerDirection.down
        
        
        // Domain Info View
        
        domainInfoView.layer.cornerRadius = 12
        /*
        domainInfoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        domainInfoView.layer.shadowColor = UIColor.black.cgColor
        domainInfoView.layer.shadowRadius = 1
        domainInfoView.layer.shadowOpacity = 0.1
        */
        domainInfoView.isUserInteractionEnabled = true
        let domainInfoViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListDetailViewController.callSafariInHostPage))
        domainInfoView.addGestureRecognizer(domainInfoViewTap)
        //domainInfoView.addGestureRecognizer(swipeDown)

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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func callSafariInHostPage() {
        let url: String = "https://" + self.domainHost.text!
        let safariViewController = SFSafariViewController(url: URL(string: url)!)
        safariViewController.modalPresentationStyle = .popover
        present(safariViewController, animated: true, completion: nil);
    }
    
    
    /*
    func swipeDownAction() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    */
    
}

extension ListDetailViewController {
    
    // TableView
    
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
        
        let safariViewController = SFSafariViewController(url: URL(string: url.url)!)
        safariViewController.modalPresentationStyle = .popover
        present(safariViewController, animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }
    
    
}

extension ListDetailViewController {
    
    // Cell
    
    func longPressHandler(sender: UILongPressGestureRecognizer) {
        //print("ListDetailViewController: Long Press")
        let point: CGPoint = sender.location(in: self.listDetailTableView)
        let indexPath = self.listDetailTableView.indexPathForRow(at: point)
        
        callActionSheet(indexPath!)
        
    }
    
    
    func callActionSheet(_ indexPath: IndexPath) {
        
        //let url = self.urls[indexPath.row].url
        //let title = self.urls[indexPath.row].title
        let sortedUrls = RealmManager.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false)
        let url = sortedUrls![indexPath.row].url
        let title = sortedUrls![indexPath.row].title
        
        
        let actionSheet: UIAlertController = UIAlertController(title: title, message: "Delete this Url.\nAre you Sure ??".localized(), preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "DELETE".localized(), style: .destructive, handler: { (action: UIAlertAction!) in
            
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
    
    // SearchBar
    /*
    // 検索ボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        self.searchResults = self.urls.filter{_ in 
            // 大文字と小文字を区別せずに検索
            //$0.lowercased().contains(searchBar.text!.lowercased())
        }
        self.listDetailTableView.reloadData()
    }
    
    // キャンセルボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.listDetailTableView.reloadData()
    }
    
    // テキストフィールド入力開始前に呼ばれる
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    */
    
    
}


extension ListDetailViewController {
    /*
    func handlePan_(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 300)
            })
            animator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            animator.fractionComplete = translation.y / 300
        case .ended:
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            return
        }
        
    }
    */
    
    func handlePan (gestureRecognizer:UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
        } else if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            
            selfViewPanDirectionY = translation.y
            //print("selfViewPanDirectionY: \(selfViewPanDirectionY)")
            
        } else if gestureRecognizer.state == .ended {
            /*
            let centerY = gestureRecognizer.view!.center.y
            print(centerY)
            
            if centerY > 420 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.00, options: .curveEaseOut, animations: {
                    gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: UIScreen.main.bounds.height/2)
                }, completion: nil)
            }
            */
            
            if (selfViewPanDirectionY > 0) {
                //print("down")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                //print("up")
                UIView.animate(withDuration: 0.2, delay: 0.00, options: .curveEaseOut, animations: {
                    gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: UIScreen.main.bounds.height/2)
                }, completion: nil)
            }
        }
        
    }
    
}
