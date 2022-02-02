

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet var imgSideBar: UIImageView!
    @IBOutlet var lblSideBarName: UILabel!
    @IBOutlet var selectionView: UIView!
    @IBOutlet var sepratorView: UIView!
    @IBOutlet var onoffSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
