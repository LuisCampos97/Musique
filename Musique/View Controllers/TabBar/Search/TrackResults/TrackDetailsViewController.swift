import UIKit
import Firebase
import FirebaseDatabase

class TrackDetailsViewController: UIViewController {
    
    var track: Track!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var addTrackToFavouritesButton: UIButton!

    
    var literalEmptyStar = UIImage()
    var literalHighlightedStar = UIImage()
    var buttonBackGround = UIImage()
    
    var ref: DatabaseReference!

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.literalEmptyStar = UIImage(named: "emptyStar")!
        self.literalHighlightedStar = UIImage(named: "highlightedStar")!
        
        imageView.image = track.album?.cover
        trackName.text = track.title
        artistName.text = track.artist?.name
        duration.text = Utils.timeString(numberToConvert: track.duration)
        albumName.text = track.album?.name
        
        self.buttonBackGround = addTrackToFavouritesButton.currentBackgroundImage!
        
             ref = Database.database().reference()

             let user = Auth.auth().currentUser
             
             db.collection("users").document(user!.uid).addSnapshotListener { documentSnapshot, error in
               guard let document = documentSnapshot else {
                 print("Error fetching document: \(error!)")
                 return
               }
               guard let data = document.data() else {
                 print("Document data was empty.")
                 return
               }
               if  (data["favouriteTracks"] != nil){
                   let tracks = data["favouriteTracks"] as! [Any]
                    for i in tracks {
                     if i as? Int == self.track?.idFromAPI {
                         self.addTrackToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "highlightedStar"), for: .normal)

                     }
                    }
               } else {
                 self.addTrackToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)

               }
             }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AlbumDetailsViewController
        vc.album = track.album
    }
    
    @IBAction func viewAlbumAction(_ sender: Any) {
        performSegue(withIdentifier: "TrackDetailsToAlbumDetails", sender: self)
    }
    
     @IBAction func addTrackToFavouritesButtonPressed(_ sender: Any) {
        
        
        self.buttonBackGround = addTrackToFavouritesButton.currentBackgroundImage!
        var literalEmptyStarData: NSData = self.literalEmptyStar.pngData()! as NSData
        var buttonBackGroundData : NSData = self.buttonBackGround.pngData()! as NSData
        
        ref = Database.database().reference()

        let user = Auth.auth().currentUser

        let favouriteTracksRef = db.collection("users").document(user!.uid)
              
        if literalEmptyStarData.isEqual(buttonBackGroundData) {
            addTrackToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "highlightedStar"), for: .normal)
            // Atomically add a new region to the "regions" array field.
            favouriteTracksRef.updateData([
                "favouriteTracks": FieldValue.arrayUnion([track?.idFromAPI])
            ])
            showToast(message: "\(track!.title) added to your favourites")

        }
        else {
            print("fica vazio")
            addTrackToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
            favouriteTracksRef.updateData([
                "favouriteTracks": FieldValue.arrayRemove([track?.idFromAPI])
            ])
            showToast(message: "\(track!.title) removed from your favourites")

        }
        

    }
    
}

extension UIViewController {
    func showToast(message: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let toastLbl = UILabel()
        toastLbl.text = message
        toastLbl.textAlignment = .center
        toastLbl.font = UIFont.systemFont(ofSize: 16)
        toastLbl.textColor = UIColor.white
        toastLbl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLbl.numberOfLines = 0
        
        
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = ( textSize.width / window.frame.width ) * 30
        let labelWidth = min(textSize.width, window.frame.width - 40)
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        
        toastLbl.frame = CGRect(x: 20, y: (window.frame.height - 90 ) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
        toastLbl.center.x = window.center.x
        toastLbl.layer.cornerRadius = 10
        toastLbl.layer.masksToBounds = true
        
        window.addSubview(toastLbl)
        
        UIView.animate(withDuration: 3.0, animations: {
            toastLbl.alpha = 0
        }) { (_) in
            toastLbl.removeFromSuperview()
        }
        
    }
}

