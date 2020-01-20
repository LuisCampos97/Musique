import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import os.log

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var favouriteArtistsCollectionView: UICollectionView!
    @IBOutlet weak var favouriteAlbumsCollectionView: UICollectionView!
    @IBOutlet weak var favouriteTracksCollectionView: UICollectionView!
    
    var artistURL = String()
    var albumURL = String()
    var trackURL = String()
    
    var artistName : String!
    var albumName : String!
    var albumID : Int!
    
    var favouriteArtists = [Artist]()
    var favouriteAlbums = [Album]()
    var favouriteTracks = [Track]()
    
    var artistIndex = Int()
    var albumIndex = Int()
    var trackIndex = Int()
    
    typealias JSONStandard = [String : AnyObject]
    var ref: DatabaseReference!

    let db = Firestore.firestore()

    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            print("teste_teste_teste_teste")
        
            favouriteArtistsCollectionView.delegate = self
            favouriteArtistsCollectionView.dataSource = self
            
            favouriteAlbumsCollectionView.delegate = self
            favouriteAlbumsCollectionView.dataSource = self
            
            favouriteTracksCollectionView.delegate = self
            favouriteTracksCollectionView.dataSource = self
            
            ref = Database.database().reference()
            
            let user = Auth.auth().currentUser

            let docRef = db.collection("users").document(user!.uid)
            
            
            db.collection("users").document(user!.uid)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
              let albums : [Any]
              let tracks : [Any]
                let artists = data["favouriteArtists"] as! [Any]
                if  (data["favouriteAlbums"] != nil){
                    albums = (data["favouriteAlbums"] as? [Any])!
                  print("albums")
              } else {
                  albums = []
              }
                if  (data["favouriteAlbums"] != nil){
                    tracks = data["favouriteTracks"] as! [Any]
                  print("albums")
              } else {
                  tracks = []
              }
                self.favouriteArtists = [Artist]()
                self.favouriteAlbums = [Album]()
                self.favouriteTracks = [Track]()
              self.callDeezerAPI(artists: artists, albums: albums, tracks: tracks)
            }
           
        }
        
        //Number of views
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == self.favouriteArtistsCollectionView {
                if (favouriteArtists.count == 0) {
                    collectionView.setEmptyMessage("You still don't have favourite artists, search for one to add it to your list")
                } else {
                    collectionView.restore()
                }
              return favouriteArtists.count
            }
            if collectionView == self.favouriteAlbumsCollectionView {
                if (favouriteAlbums.count == 0) {
                    collectionView.setEmptyMessage("You still don't have favourite albums, search for one to add it to your list")
                } else {
                    collectionView.restore()
                }
                return favouriteAlbums.count
            }
            else {
                if (favouriteTracks.count == 0) {
                    collectionView.setEmptyMessage("You still don't have favourite tracks, search for one to add it to your list")
                } else {
                    collectionView.restore()
                }
                return favouriteTracks.count
            }
          }
          
        //Populate view
          func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if collectionView == self.favouriteArtistsCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistsCell", for: indexPath) as! FavouritesCollectionViewCell
                cell.favouritesImageView.layer.cornerRadius = 12
                cell.favouritesImageView.image = self.favouriteArtists[indexPath.row].image
                cell.favouritesLabel.text = self.favouriteArtists[indexPath.row].name
                return cell
            }
            if collectionView == self.favouriteAlbumsCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumsCell", for: indexPath) as! FavouritesCollectionViewCell
                cell.favouritesImageView.layer.cornerRadius = 12
                cell.favouritesImageView.image = self.favouriteAlbums[indexPath.row].cover
                cell.favouritesLabel.text = self.favouriteAlbums[indexPath.row].name
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tracksCell", for: indexPath) as! FavouritesCollectionViewCell
                cell.favouritesImageView.layer.cornerRadius = 12
                cell.favouritesImageView.image = self.favouriteTracks[indexPath.row].image
                cell.favouritesLabel.text = self.favouriteTracks[indexPath.row].title
                return cell
            }
            
          }

        
        func callDeezerAPI(artists: [Any], albums: [Any], tracks: [Any]) {
            for i in artists {
                artistURL = "https://api.deezer.com/artist/\(i)"
                AF.request(artistURL).responseJSON(completionHandler: {
                    response in
                    self.parseDataArtist(JSONData: response.data!)
                })
            }
           for i in albums {
               albumURL = "https://api.deezer.com/album/\(i)"
               AF.request(albumURL).responseJSON(completionHandler: {
                   response in
                   self.parseDataAlbum(JSONData: response.data!)
               })
           }
           for i in tracks {
               trackURL = "https://api.deezer.com/track/\(i)"
               AF.request(trackURL).responseJSON(completionHandler: {
                   response in
                   self.parseDataTrack(JSONData: response.data!)
               })
           }
               
           }
           
           func parseDataArtist(JSONData : Data) {
               do {
                    let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
                    let idFromAPI = readableJSON["id"] as? Int
                    let artistName = readableJSON["name"] as? String
                    let mainImageURL =  URL(string: readableJSON["picture_xl"] as! String)
                    let mainImageData = NSData(contentsOf: mainImageURL!)
                    let mainImage = UIImage(data: mainImageData! as Data)
                         
                    addArtist((Artist.init(idFromAPI: idFromAPI!, name: artistName!, image: mainImage!))!)
                    self.favouriteArtistsCollectionView.reloadInputViews()
                    self.favouriteArtistsCollectionView.reloadData()
                   
               }
               catch{
                   print(error)
               }
           }
        
        func parseDataAlbum(JSONData : Data) {
            var artistName : String?

            do {
                 let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
                 let idFromAPI = readableJSON["id"] as? Int
                 let albumTitle = readableJSON["title"] as? String
                 let mainImageURL =  URL(string: readableJSON["cover_xl"] as! String)
                 let mainImageData = NSData(contentsOf: mainImageURL!)
                 let mainImage = UIImage(data: mainImageData! as Data)
                
                if let artist = readableJSON["artist"] as? JSONStandard {
                    artistName =  artist["name"] as? String
                }
                     let artista = (Artist.init(idFromAPI: idFromAPI!, name: artistName!, image: mainImage!))!
                
                 addAlbum((Album.init(idFromAPI: idFromAPI!, name: albumTitle!, cover: mainImage!, artist: artista))!)
                 self.favouriteAlbumsCollectionView.reloadInputViews()
                 self.favouriteAlbumsCollectionView.reloadData()
                
            }
            catch{
                print(error)
            }
        }
        
        func parseDataTrack(JSONData : Data) {
            var mainImageArtist : UIImage?

            do {
                 let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
                 let idFromAPI = readableJSON["id"] as! Int
                 let trackName = readableJSON["title"] as! String
                let duration = readableJSON["duration"] as! Int
                if let artist = readableJSON["artist"] as? JSONStandard {
                    artistName = artist["name"] as? String
                    let mainImageURLArtist =  URL(string: artist["picture"] as! String)
                    let mainImageDataArtist = NSData(contentsOf: mainImageURLArtist!)
                    mainImageArtist = UIImage(data: mainImageDataArtist! as Data)!
                }
                
                let artistObject = Artist(idFromAPI: idFromAPI, name: artistName, image: mainImageArtist!)
                
                
                   
                if let album = readableJSON["album"] as? JSONStandard{
                let mainImageURL =  URL(string: album["cover_big"] as! String)
                let mainImageData = NSData(contentsOf: mainImageURL!)
                let cover = UIImage(data: mainImageData! as Data)!
                
                albumName = album["title"] as? String
                albumID = album["id"] as? Int
                
                let album = Album.init(idFromAPI: albumID, name: albumName, cover: cover, artist: artistObject)
                
                    let track = Track.init(idFromAPI: idFromAPI, title: trackName, duration: duration, image: mainImageArtist!)
                track?.album = album
                track?.artist = artistObject
                    addTrack(track!)
                 self.favouriteTracksCollectionView.reloadInputViews()
                 self.favouriteTracksCollectionView.reloadData()
                }
            }
            catch{
                print(error)
            }
        }
           
        fileprivate func addArtist(_ artist: Artist) {
            
           favouriteArtists.append(artist)
        }
        fileprivate func addAlbum(_ album: Album) {
            favouriteAlbums.append(album)
        }
        fileprivate func addTrack(_ track: Track) {
            favouriteTracks.append(track)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.favouriteArtistsCollectionView {
            artistIndex = indexPath.row
            self.performSegue(withIdentifier: "FavouritesToArtistSegue", sender: self)

        }
        if collectionView == self.favouriteAlbumsCollectionView {
            albumIndex = indexPath.row
            self.performSegue(withIdentifier: "FavouritesToAlbumSegue", sender: self)
        }
        else {
            trackIndex = indexPath.row
            self.performSegue(withIdentifier: "FavouritesToTrackSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               if(segue.identifier == "FavouritesToArtistSegue") {
                   let vc = segue.destination as! ArtistDetailsViewController
                   vc.artist = favouriteArtists[artistIndex]
               }
               if(segue.identifier == "FavouritesToAlbumSegue") {
                   let vc = segue.destination as! AlbumDetailsViewController
                   vc.album = favouriteAlbums[albumIndex]
               }
               if(segue.identifier == "FavouritesToTrackSegue") {
                   let vc = segue.destination as! TrackDetailsViewController
                   vc.track = favouriteTracks[trackIndex]
               }
               
           }
        
       
    }

    extension UICollectionView {

        func setEmptyMessage(_ message: String) {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .white
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()

            self.backgroundView = messageLabel;
        }

        func restore() {
            self.backgroundView = nil
        }
    }
