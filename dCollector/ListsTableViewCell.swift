
import UIKit

class ListsTableViewCell: UITableViewCell {

    @IBOutlet weak var domainIcon: UIImageView!
    @IBOutlet weak var domainCount: UILabel!
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        domainCount.textColor = UIColor.hexStr(type: .blue1, alpha: 1.0)
        domainHost.textColor = UIColor.hexStr(type: .textLight, alpha: 1.0)
        
        self.accessoryType = .none
    }
}
