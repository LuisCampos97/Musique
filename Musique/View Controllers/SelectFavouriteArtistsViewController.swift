import UIKit

class SelectFavouriteArtistsViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Hi " + name + ", choose three or more artists to add to favourites"
    }
}
