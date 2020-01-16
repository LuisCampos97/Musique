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
        duration.text = timeString(numberToConvert: track.duration)
        albumName.text = track.album?.name
    }
    
    func timeString(numberToConvert: Int) -> String {
        let minute = Int(numberToConvert) / 60 % 60
        let second = Int(numberToConvert) % 60

        return String(format: "%02i:%02i", minute, second)
    }
    
    @IBAction func viewAlbumAction(_ sender: Any) {
        
        performSegue(withIdentifier: "TrackDetailsToAlbumDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AlbumDetailsViewController
        vc.album = track.album
    }
    

}
