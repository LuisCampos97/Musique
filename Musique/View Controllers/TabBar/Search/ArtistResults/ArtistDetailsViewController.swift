import UIKit
import Alamofire
import Firebase
import FirebaseDatabase

class ArtistDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    @IBOutlet weak var addArtistToFavouritesButton: UIButton!
    //Artist from SearchTableViewController
    var artist: Artist?
    
    var isArtistFav = UserDefaults.standard.bool(forKey: "isArtistFav")

    var literalEmptyStar = UIImage()
    var literalHighlightedStar = UIImage()
    var buttonBackGround = UIImage()
    
    var urlAlbums = String()
    var urlTopTracks = String()
    
    var albums = [Album]()
    var topTracks = [Track]()
    
    typealias JSONStandard = [String : AnyObject]
    
    var ref: DatabaseReference!

       let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.literalEmptyStar = UIImage(named: "emptyStar")!
        self.literalHighlightedStar = UIImage(named: "highlightedStar")!
        
        
        urlAlbums = "https://api.deezer.com/artist/\(String(artist!.idFromAPI))/albums"
        urlTopTracks = "https://api.deezer.com/artist/\(String(artist!.idFromAPI))/top"
        
        //MARK: Search in API the artist's albums
        AF.request(urlAlbums).responseJSON(completionHandler: {
            response in
            self.parseDataAlbums(JSONData: response.data!)
        })
        
        //MARK: Search in API the artist's top 5 tracks
        AF.request(urlTopTracks).responseJSON(completionHandler: {
            response in
            self.parseDataTracks(JSONData: response.data!)
        })
        
        self.buttonBackGround = addArtistToFavouritesButton.currentBackgroundImage!
   
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
          if  (data["favouriteArtists"] != nil){
              let artists = data["favouriteArtists"] as! [Any]
               for i in artists {
                if i as? Int == self.artist?.idFromAPI {
                    self.addArtistToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "highlightedStar"), for: .normal)

                }
               }
          } else {
            self.addArtistToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)

          }
        }
        
     }
   
   
     @IBAction func addArtistToFavouritesButtonPressed(_ sender: Any) {
        
        
        self.buttonBackGround = addArtistToFavouritesButton.currentBackgroundImage!
        var literalEmptyStarData: NSData = self.literalEmptyStar.pngData()! as NSData
        var buttonBackGroundData : NSData = self.buttonBackGround.pngData()! as NSData
        
        ref = Database.database().reference()

        let user = Auth.auth().currentUser

        let favourtieArtistsRef = db.collection("users").document(user!.uid)
              
        if literalEmptyStarData.isEqual(buttonBackGroundData) {
            addArtistToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "highlightedStar"), for: .normal)
            // Atomically add a new region to the "regions" array field.
            favourtieArtistsRef.updateData([
                "favouriteArtists": FieldValue.arrayUnion([artist?.idFromAPI])
            ])
            showToast(message: "\(artist!.name) added to your favourites")
        }
        else {
            print("fica vazio")
            addArtistToFavouritesButton.setBackgroundImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
            favourtieArtistsRef.updateData([
                "favouriteArtists": FieldValue.arrayRemove([artist?.idFromAPI])
            ])
            showToast(message: "\(artist!.name) removed from your favourites")

        }
        

    }
    
    
    //MARK: Get albums from Artist's albums
    func parseDataAlbums(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            if let albumsData = readableJSON["data"] as? [JSONStandard] {
                for i in 0..<albumsData.count {
                    let albumData = albumsData[i]
                    
                    let idFromAPI = albumData["id"] as! Int
                    let name = albumData["title"] as! String
                    
                    let mainImageURL =  URL(string: albumData["cover_big"] as! String)
                    let mainImageData = NSData(contentsOf: mainImageURL!)
                    let cover = UIImage(data: mainImageData! as Data)!
                    
                    let album = Album(idFromAPI: idFromAPI, name: name, cover: cover, artist: artist)
                    
                    addAlbum(album: album!)
                    self.collectionVIew.reloadData()
                    
                }
                
            }
        } catch {
            print(error)
        }
    }
    
    func addAlbum(album: Album) {
        let newIndexPath = IndexPath(row: albums.count, section: 0)
        albums.append(album)
        collectionVIew.insertItems(at: [newIndexPath])
    }
    
    //MARK: Get top5 tracks from Artist
    func parseDataTracks(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            if let tracksData = readableJSON["data"] as? [JSONStandard] {
                for i in 0..<tracksData.count {
                    let trackData = tracksData[i]
                    
                    let idFromAPI = trackData["id"] as! Int
                    let tile = trackData["title"] as! String
                    let duration = trackData["duration"] as! Int
                    
                    if let album = trackData["album"] as? JSONStandard{
                        let mainImageURL =  URL(string: album["cover_big"] as! String)
                        let mainImageData = NSData(contentsOf: mainImageURL!)
                        let cover = UIImage(data: mainImageData! as Data)!
                        
                        let albumName = album["title"] as? String
                        let albumID = album["id"] as? Int
                        
                        let album = Album.init(idFromAPI: albumID!, name: albumName!, cover: cover, artist: artist)
                        
                        let track = Track.init(idFromAPI: idFromAPI, title: tile, duration: duration, image: cover)
                        track?.album = album
                        track?.artist = artist
                        
                        addTrack(track: track!)
                        
                        artistName.text = artist?.name
                        artistImage.image = artist?.image
                        
                        self.tableView.reloadData()
                    }
                }
                
            }
        } catch {
            print(error)
        }
    }
    
    fileprivate func addTrack(track: Track) {
        let newIndexPath = IndexPath(row: topTracks.count, section: 0)
        topTracks.append(track)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
    }
    
    //MARK: TableView data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopTrackCell", for: indexPath) as? ArtistDetailsTableViewCell
        
        let track = topTracks[indexPath.row]
        cell?.trackName.text = track.title
        cell?.trackDuration.text = Utils.timeString(numberToConvert: track.duration)
        
        return cell!
    }
    
    //MARK: CollectionView data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumsArtistDetailsCollectionViewCell
        
        let album = albums[indexPath.row]
        cell!.albumCover.image = album.cover
        
        return cell!
    }
    
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Data to send from TableView
        if(segue.identifier == "ArtistDetailsToTrackDetails") {
            let indexPathTableView = self.tableView.indexPathForSelectedRow
            
            let tdvc = segue.destination as! TrackDetailsViewController
            tdvc.track = topTracks[indexPathTableView!.row]
        } else {
            //Data to send from CollectionView
            let cell =    sender as! AlbumsArtistDetailsCollectionViewCell
            let indexPathCollectionView = self.collectionVIew.indexPath(for: cell)
            
            let adbc = segue.destination as! AlbumDetailsViewController
            adbc.album = albums[indexPathCollectionView!.row]
        }
    }
}
    
