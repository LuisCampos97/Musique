import UIKit

class AlbumDetailsViewController: UIViewController {
    
    var album: Album!
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCover.image = album.cover
        albumTitle.text = album.name
    }
}
