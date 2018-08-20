
import UIKit
import SafariServices

final class ListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var listDetailTableView: UITableView!
    fileprivate let listDetailTableViewContentInset: CGFloat = 24.0
    @IBOutlet weak var listDetailTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var domainInfoView: UIView!
    public let domainInfoViewTopMargin: CGFloat = 24.0
    @IBOutlet weak var domainInfoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var domainIcon: UIImageView?
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    @IBOutlet weak var domainDescription: UILabel!
    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!
    
    fileprivate var selfDidAppeared: Bool = false
    fileprivate var pullDismissing: Bool = false
    fileprivate var nowDismissing: Bool = false
    fileprivate var prevPanTranslationY: CGFloat = 0.0
    fileprivate var panDirection: PanningTo = .Down
    fileprivate enum PanningTo {
        case Up, Down
    }
    fileprivate var pullToDismiss: PullToDismissService?
    
    @IBAction func closeButtonHandle(_ sender: UIButton) {
        pullToDismiss?.start()
    }
    
    var selectedDomain: Domain? {
        didSet {
            configureDomainView()
        }
    }
    var urls: [Url] = []
    
    override func loadView() {
        super.loadView()
        
        let nib: UINib = UINib(nibName: "ListDetailTableViewCell", bundle: nil)
        listDetailTableView.register(nib, forCellReuseIdentifier: "ListDetailTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        selfDidAppeared = true
    }
    
    deinit {
        listDetailTableView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    private func initUIs() {
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        listDetailTableView.delegate = self
        listDetailTableView.dataSource = self
        listDetailTableView.rowHeight = 70.0
        listDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        listDetailTableView.separatorColor = UIColor.hexStr(type: .textBlack, alpha: 0.16)
        listDetailTableView.contentInset = UIEdgeInsetsMake(listDetailTableViewContentInset, 0.0, listDetailTableViewContentInset, 0.0)
        setHeightForTableView()
        // Long Press
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPress.allowableMovement = 400
        longPress.minimumPressDuration = 0.6
        longPress.numberOfTapsRequired = 0
        longPress.numberOfTouchesRequired = 1
        listDetailTableView.addGestureRecognizer(longPress)
        
        domainInfoView.isUserInteractionEnabled = true
        let domainInfoViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callSafariInHostPage))
        domainInfoView.addGestureRecognizer(domainInfoViewTap)
        if #available(iOS 11.0, *) {
            domainInfoView.clipsToBounds = true
            domainInfoView.layer.cornerRadius = 15.0
            domainInfoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        domainInfoViewTopConstraint.constant = domainInfoViewTopMargin
        
        pullToDismiss = PullToDismissService(in: self)
        pullToDismiss!.ready()
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
    
    @objc func callSafariInHostPage() {
        let url: Url = Url()
        url.url = "https://" + self.domainHost.text!
        openBrowser(url: url)
    }
    
    func openBrowser(url: Url) {
        
        switch AppSettings.broswerIs() {
            
        case 0:
            let safariViewController = SFSafariViewController(url: URL(string: url.url)!)
            safariViewController.modalPresentationStyle = .popover
            present(safariViewController, animated: true, completion: nil)
            
        case 1:
            let url: URL = URL(string:"\(url.url)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        case 2:
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
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y <= -(listDetailTableViewContentInset) &&
           scrollView.panGestureRecognizer.velocity(in: self.view).y > 0
        {
            pullDismissing = true
            pullToDismiss?.ready()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if pullDismissing == false { return }
        if nowDismissing == true { return }
        
        let translationY = scrollView.panGestureRecognizer.translation(in: self.view).y
        pullToDismiss?.onFraction(translationY)
        
        if translationY - prevPanTranslationY != 0 {
            panDirection = (translationY - prevPanTranslationY) > 0 ? .Down : .Up
            prevPanTranslationY = translationY
        }
        scrollView.contentOffset.y = -listDetailTableViewContentInset // reset
    }
    
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if pullDismissing == false { return }
    
        if panDirection == .Down {
            nowDismissing = true
            pullToDismiss?.continueAnimation()
        } else {
            pullToDismiss?.reverse()
            prevPanTranslationY = 0.0
            pullDismissing = false
        }
    }
}


// MARK: TableView

extension ListDetailViewController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sortedUrls = RealmService.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false) else {
            return 0
        }
        return sortedUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let sortedUrls = RealmService.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false) else {
            return UITableViewCell()
        }
        
        let selectedUrl = sortedUrls[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailTableViewCell", for: indexPath) as! ListDetailTableViewCell
        cell.urlTitle?.text = selectedUrl.title
        cell.url?.text = selectedUrl.url
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        guard let sortedUrls = RealmService.getDomainByName(selectedDomain!.name)?.urls.sorted(byKeyPath: "createdAt", ascending: false) else { return }
        
        openBrowser(url: sortedUrls[indexPath.row])
    }
}

// MARK: TableView Cell

extension ListDetailViewController {
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {

            let point: CGPoint = sender.location(in: self.listDetailTableView)
            guard let indexPath = self.listDetailTableView.indexPathForRow(at: point) else { return }
            
            callActionSheet(indexPath)
        }
    }
    
    
    func callActionSheet(_ indexPath: IndexPath) {

        guard
            let selectedDomain = self.selectedDomain,
            let domain = RealmService.getDomainWithPrimaryKey(selectedDomain.name)
        else {
            return
        }
        let sortedUrls = domain.urls.sorted(byKeyPath: "createdAt", ascending: false)
        let url = sortedUrls[indexPath.row].url
        let title = sortedUrls[indexPath.row].title
        
        let actionSheet: UIAlertController = UIAlertController(title: title, message: "Delete this Url.\nAre you Sure ??".localized(), preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "DELETE".localized(), style: .destructive, handler: { _ in DispatchQueue.main.async {
            
            guard let deleteUrl = RealmService.getUrlWithPrimaryKey(url) else {
                return
            }
            RealmService.deleteUrl(url: deleteUrl)
            
            self.urls.removeAll()
            for _url in domain.urls {
                self.urls.append(_url)
            }
            
            let table = self.listDetailTableView!
            table.beginUpdates()
            table.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            table.perform(#selector(table.reloadData), with: nil, afterDelay: 0.3)
            table.layoutIfNeeded()
            table.endUpdates()
        }})
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        actionSheet.addAction(ok)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
}

extension ListDetailViewController {
    
    @objc func handlePan (gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            pullToDismiss?.ready()
            
        } else if gestureRecognizer.state == .changed {
            
            let translationY = gestureRecognizer.translation(in: self.view).y
            pullToDismiss?.onFraction(translationY)
            
            if translationY - prevPanTranslationY != 0 {
                panDirection = (translationY - prevPanTranslationY) > 0 ? .Down : .Up
                prevPanTranslationY = translationY
            }
            
        } else if gestureRecognizer.state == .ended {
            
            if panDirection == .Down {
                self.pullToDismiss?.continueAnimation()
            } else {

                self.pullToDismiss?.reverse()
                prevPanTranslationY = 0.0
            }
        }
    }
    
    
}
