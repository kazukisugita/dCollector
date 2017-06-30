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

    @IBOutlet weak var listDetailTableView: UITableView!

    @IBOutlet weak var domainInfoView: UIView!
    @IBOutlet weak var domainIcon: UIImageView?
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    @IBOutlet weak var domainDescription: UILabel!
    
    var selectedDomain: Domain? {
        didSet {
            configureDomain()
        }
    }
    var urls: [Url] = []
    
    fileprivate var selfViewPanDirectionX: CGFloat = 0.0
    fileprivate var panBlock: Bool = false
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Self View
        
        self.view.alpha = 1.0
    
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ListDetailViewController.handlePan(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        // TableView
    
        listDetailTableView.delegate = self
        listDetailTableView.dataSource = self
        
        listDetailTableView.rowHeight = 98.0 + 20.0
        listDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //listDetailTableView.separatorColor = UIColor.hexStr(type: .textBlack, alpha: 0.16)
        listDetailTableView.contentInset = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)
        
        //let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ListDetailViewController.swipeDownTableView(sendor:)))
        //swipeGesture.direction = .down
        //listDetailTableView.addGestureRecognizer(swipeGesture)
        
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
        
        // Domain Info View
        
        configureDomainInfoView()
    
    }
    
    
    func configureDomainInfoView() {
        
        //domainInfoView.layer.cornerRadius = 12
        //domainInfoView.isUserInteractionEnabled = true
        //let domainInfoViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListDetailViewController.callSafariInHostPage))
        //domainInfoView.addGestureRecognizer(domainInfoViewTap)
        
    
        let leftColor = UIColor.hexStrRaw(hex: "#9FA8DA", alpha: 1.0).cgColor
        let rightColor = UIColor.hexStrRaw(hex: "#90CAF9", alpha: 1.0).cgColor
        
        let gradientColors: [CGColor] = [leftColor, rightColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = domainInfoView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        domainInfoView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func configureDomain() {
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
        //safariViewController.modalPresentationStyle = .popover
        present(safariViewController, animated: true, completion: nil);
    }
    
    
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
        
        print("tap tap !!")
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        var url: Url!
        let sortedUrls = RealmManager.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false)
        url = sortedUrls![indexPath.row]
        
        let safariViewController = SFSafariViewController(url: URL(string: url.url)!)
        //safariViewController.modalPresentationStyle = .popover
        present(safariViewController, animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("hogehoge!!")
    }
    
    
}

extension ListDetailViewController {
    
    // Cell
    
    func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {

            let point: CGPoint = sender.location(in: self.listDetailTableView)
            let indexPath = self.listDetailTableView.indexPathForRow(at: point)
        
            callActionSheet(indexPath!)
        }
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
            
        } else if gestureRecognizer.state == .changed && panBlock == false {
            
            let translation = gestureRecognizer.translation(in: self.view)

            if ((gestureRecognizer.view!.center.x + translation.x) <= UIScreen.main.bounds.width/2) { return }
            
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            
            selfViewPanDirectionX = translation.x
            
            //print(gestureRecognizer.view!.center.x)
            
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
            
            if (selfViewPanDirectionX > 0) {
                //print("down")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "listsViewReload"), object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                //print("up")
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.view!.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                }, completion: nil)
            }
        }
        
    }
    
    
}
