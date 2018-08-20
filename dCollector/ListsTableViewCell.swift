
import UIKit

class ListsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var domainIcon: UIImageView!
    @IBOutlet weak var domainCount: UILabel!
    @IBOutlet weak var domainHost: UILabel!
    @IBOutlet weak var domainTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.accessoryType = .none
    }
}
