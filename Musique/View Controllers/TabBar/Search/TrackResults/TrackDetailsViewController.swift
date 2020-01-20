import UIKit

class TrackDetailsViewController: UIViewController {
    
    var track: Track!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = track.album?.cover
        trackName.text = track.title
        artistName.text = track.artist?.name
        duration.text = Utils.timeString(numberToConvert: track.duration)
        albumName.text = track.album?.name
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AlbumDetailsViewController
        vc.album = track.album
    }
    
    @IBAction func viewAlbumAction(_ sender: Any) {
        performSegue(withIdentifier: "TrackDetailsToAlbumDetails", sender: self)
    }
    
}
