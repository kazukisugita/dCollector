
import UIKit

class ListDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var urlTitle: UILabel!
    @IBOutlet weak var urlCreatedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        url.textColor = UIColor.hexStr(type: .textLight, alpha: 1.0)
    }
    
}
