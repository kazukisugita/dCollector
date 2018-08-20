
import UIKit

class ListsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var domainIcon: UIImageView!
    @IBOutlet weak var domainCount: UILabel!
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //domainCount.textColor = UIColor.hexStr(type: .blue1, alpha: 1.0)
        domainHost.textColor = UIColor.hexStr(type: .textBlack_light_v2, alpha: 1.0)
        domainTitle.textColor = UIColor.hexStr(type: .textBlack_light_Domains_v2, alpha: 1.0)
        
        containerView.clipsToBounds = false
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowColor = UIColor.hexStr(type: .shadow, alpha: 1.0).cgColor
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.16

        self.accessoryType = .none
    }
}
