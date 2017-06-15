//
//  CollectionViewController.swift
//  dCollector
//
//  Created by Kazuki Sugita on 2017/05/15.
//  Copyright © 2017年 Kazuki Sugita. All rights reserved.
//

import UIKit
import Ji

final class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var refresher: UIRefreshControl!
    
//    var domainsForDisplay: [Domain] = []
    var selectedDomain: Domain!
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    
    override func viewWillAppear(_ animated: Bool) {
        // Called when the view is about to made visible. Default does nothing
//        print(" *** CollectionViewController viewWillAppear*** ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Called when the view has been fully transitioned onto the screen. Default does nothing
        
        print(" *** CollectionViewController viewDidAppear*** ")

//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationDidBecomeActiveNotification"), object: nil)
        
//        Transaction.fromUserdefaultsfToRealm()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
//        print(" *** CollectionViewController viewWillDisappear*** ")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
//        print(" *** CollectionViewController viewDidDisappear*** ")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Self View
        title = "Domains"
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationDidBecomeActiveNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollectionViewController.refreshView), name: NSNotification.Name(rawValue: "applicationDidBecomeActiveNotification"), object: nil)
        
        // CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.hexStr(type: Colors.grayBack, alpha: 1.0)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.bounds.size.width * 0.9), height: 60.0)
        
        collectionView.collectionViewLayout = layout
        
        let nib: UINib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionCellNib")
        
        // CollectionView Refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "")
        refresher.addTarget(self, action: #selector(CollectionViewController.refreshView), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refresher)
        
        
//        setDomainsForDisplay()
        
    }
    
    deinit {
        // 通知を解除
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    func setDomainsForDisplay() {
        
        domainsForDisplay.removeAll()
        
        let domains = RealmManager.getAllDomain()
        
        for domain in domains {
            domainsForDisplay.append(domain)
            
            if domain.icon == nil {
                print("\(domain.name)'s icon is nil")
            }
        }
    }
    */
 
}

extension CollectionViewController {
    /*
     Cellの総数を返す
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return domainsForDisplay.count
        return RealmManager.getAllDomain().count
    }
    
    /*
     Cellに値を設定する
     */
    /*
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let domain = self.domainsForDisplay[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellNib", for: indexPath as IndexPath) as! CustomCollectionViewCell
        cell.domainLabel.text = domain.name
        cell.domainHasUrls.text = String(domain.urls.count)
        cell.domainTitle.text = domain.title
        cell.domainDescription.text = domain.siteDescription
        
        return cell
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let domain = self.domainsForDisplay[indexPath.row]
        
        let domain = RealmManager.getAllDomain()[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellNib", for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        cell.domainLabel.text = domain.name
        cell.domainHasUrls.text = String(domain.urls.count)

        // domain.title
        if (domain.title == nil) {
            
            let jiObject = Ji(htmlURL: URL(string: "https://" + domain.name)!)
            
            if let node = jiObject?.xPath("//head/title")?.first {
                let str = node.content!
                cell.domainTitle.text = str
                
                let object = RealmManager.getDomainWithPrimaryKey(domain.name)
                RealmManager.rewriteSpecificDomainTitle(object!, str: str)
            }
            
        } else {
            
            cell.domainTitle?.text = domain.title
            
        }
        
        // domain.siteDescription
        if (domain.siteDescription == nil) {
            
            let jiObject = Ji(htmlURL: URL(string: "https://" + domain.name)!)
            
            if let node = jiObject?.xPath("//head/meta[@name='description']")?.first {
                let str = node["content"]!
                cell.domainDescription.text = str
                
                let object = RealmManager.getDomainWithPrimaryKey(domain.name)
                RealmManager.rewriteSpecificDomainSiteDescription(object!, str: str)
            }
            
        } else {
            
            cell.domainDescription?.text = domain.siteDescription
            
        }
        
        // domain.icon
        if (domain.icon == nil) {
            //print(domain.name)
            
            var iconPath: String?
            
            let jiObject = Ji(htmlURL: URL(string: "https://" + domain.name)!)
            
            if let node = jiObject?.xPath("//head/link[@rell='shortcut icon']")?.first {
                iconPath = node["href"]!
            }
            
            if iconPath == nil {
                if let node = jiObject?.xPath("//head/link[@rell='icon']")?.first {
                    iconPath = node["href"]!
                }
            }
            
//            var _url: String
//            
//            if let path = iconPath {
//                _url = path
//            } else {
//                _url = "/favicon.ico"
//            }

            let url:URL! = URL(string: "https://" + domain.name + iconPath!)
//            let url:URL! = URL(string: "https://" + domain.name + _url)
            
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        cell.domainIcon.image = UIImage(data: data)
                        
                        let object = RealmManager.getDomainWithPrimaryKey(domain.name)
                        RealmManager.rewriteSpecificDomain(object!, image: data as NSData)
                    })
                }
            })
            task.resume()
        } else {
            
            cell.domainIcon?.image = UIImage(data: domain.icon! as Data)
            
        }
        
        return cell
    }
    
    /*
     Cellが選択された際に呼び出される
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        print("Num: \(indexPath.row)")
//        print("Value:\(collectionView)")
        
        self.selectedDomain = RealmManager.getAllDomain()[indexPath.row]
        
        performSegue(withIdentifier: "toCollectionFromLists", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "toCollectionFromLists") {
            
            if let vc: ListDetailViewController = segue.destination as? ListDetailViewController {
                vc.selectedDomain = self.selectedDomain
            } else {
                print("segue fail")
            }
            
        }
    }
    
}

extension CollectionViewController {
    
    func refreshView() {
        
        print(" *** CollectionViewController.refreshView() *** ")

        self.refresher.beginRefreshing()
        
        DispatchQueue.main.async(execute: { () -> Void in
//            self.setDomainsForDisplay()
            
            self.collectionView.reloadData()
            self.refresher.endRefreshing()
        })
        
    }
}

extension CollectionViewController {
    
    
    
}
