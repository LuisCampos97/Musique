import UIKit

class ArtistDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
