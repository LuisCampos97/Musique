import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import CoreLocation
import os.log

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var topArtistsCollectionView: UICollectionView!
    @IBOutlet weak var topAlbumsCollectionView: UICollectionView!
    @IBOutlet weak var topTracksCollectionView: UICollectionView!
    
    
    var artistURL = String()
    var albumURL = String()
    var trackURL = String()
    
    var artistName : String!
    var albumName : String!
    var albumID : Int!
    
    var topArtists = [Artist]()
    var topAlbums = [Album]()
    var topTracks = [Track]()
    
    var artistIndex = Int()
    var albumIndex = Int()
    var trackIndex = Int()
    
    var locationManager:CLLocationManager!
    var latitude = String()
    var longitude = String()
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callDeezerAPI()
        
        topArtistsCollectionView.delegate = self
        topArtistsCollectionView.dataSource = self
        
        topAlbumsCollectionView.delegate = self
        topAlbumsCollectionView.dataSource = self
        
        topTracksCollectionView.delegate = self
        topTracksCollectionView.dataSource = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        self.becomeFirstResponder()
    }
    
    //MARK: Localization
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation :CLLocation = locations[0] as CLLocation
        
        let latitudeFromLocation = userLocation.coordinate.latitude as Double
        let longitudeFromLocation = userLocation.coordinate.longitude as Double
        
        latitude = String(round(1000*latitudeFromLocation)/1000)
        longitude = String(round(1000*longitudeFromLocation)/1000)
    }
    
    //MARK: Shake feature
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            if CLLocationManager.locationServicesEnabled() == true {
                
                if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                    
                    locationManager.requestWhenInUseAuthorization()
                }
                
                locationManager.desiredAccuracy = 1.0
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            
                AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&APPID=e7b2054dc37b1f464d912c00dd309595&units=Metric").responseJSON(completionHandler: {
                    response in
                    self.parseDataWeather(JSONData: response.data!)
                })
                
            } else {
                let alertController = UIAlertController(title: "Warning", message:
                    "Please enable Location Services", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func parseDataWeather(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let weatherData = readableJSON["weather"] as? [JSONStandard] {
                let weatherMain = weatherData[0]
                
                let weather = weatherMain["main"] as! String
                
                if(weather == "Clouds") {
                    
                }
            }
        } catch {
            print(error)
        }
    }
    
    //Number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topArtistsCollectionView {
            return topArtists.count
        }
        if collectionView == self.topAlbumsCollectionView {
            return topAlbums.count
        }
        else {
            return topTracks.count
        }
    }
    
    //Populate view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.topArtistsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topArtistsCell", for: indexPath) as! HomeCollectionViewCell
            cell.topArtistsView.layer.cornerRadius = 12
            cell.topArtistsView.image = self.topArtists[indexPath.row].image
            cell.topArtistsLabel.text = self.topArtists[indexPath.row].name
            return cell
        }
        if collectionView == self.topAlbumsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topAlbumsCell", for: indexPath) as! HomeCollectionViewCell
            cell.topAlbumsView.layer.cornerRadius = 12
            cell.topAlbumsView.image = self.topAlbums[indexPath.row].cover
            cell.topAlbumsLabel.text = self.topAlbums[indexPath.row].name
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topTracksCell", for: indexPath) as! HomeCollectionViewCell
            cell.topTracksView.layer.cornerRadius = 12
            cell.topTracksView.image = self.topTracks[indexPath.row].image
            cell.topTracksLabel.text = self.topTracks[indexPath.row].title
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.topArtistsCollectionView {
            artistIndex = indexPath.row
            self.performSegue(withIdentifier: "HomeToArtistSegue", sender: self)
            
        }
        if collectionView == self.topAlbumsCollectionView {
            albumIndex = indexPath.row
            self.performSegue(withIdentifier: "HomeToAlbumSegue", sender: self)
        }
        else {
            trackIndex = indexPath.row
            self.performSegue(withIdentifier: "HomeToTrackSegue", sender: self)
        }
    }
    
    func callDeezerAPI() {
        
        artistURL = "https://api.deezer.com/chart/0/artists"
        AF.request(artistURL).responseJSON(completionHandler: {
            response in
            self.parseDataArtist(JSONData: response.data!)
        })
        
        
        albumURL = "https://api.deezer.com/chart/0/albums"
        AF.request(albumURL).responseJSON(completionHandler: {
            response in
            self.parseDataAlbum(JSONData: response.data!)
        })
        
        
        trackURL = "https://api.deezer.com/chart/0/tracks"
        AF.request(trackURL).responseJSON(completionHandler: {
            response in
            self.parseDataTrack(JSONData: response.data!)
        })
        
        
    }
    
    func parseDataArtist(JSONData : Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let artistsData = readableJSON["data"] as? [JSONStandard]{
                for i in 0..<artistsData.count{
                    let item = artistsData[i]
                    let idFromAPI = item["id"] as? Int
                    let artistName = item["name"] as? String
                    let mainImageURL =  URL(string: item["picture_xl"] as! String)
                    let mainImageData = NSData(contentsOf: mainImageURL!)
                    let mainImage = UIImage(data: mainImageData! as Data)
                    
                    addArtist((Artist.init(idFromAPI: idFromAPI!, name: artistName!, image: mainImage!))!)
                    self.topArtistsCollectionView.reloadInputViews()
                    self.topArtistsCollectionView.reloadData()
                }
            }
        }
        catch{
            print(error)
        }
    }
    
    func parseDataAlbum(JSONData : Data) {
        
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let albumsData = readableJSON["data"] as? [JSONStandard]{
                for i in 0..<albumsData.count{
                    let item = albumsData[i]
                    let idFromAPI = item["id"] as? Int
                    let albumTitle = item["title"] as? String
                    let mainImageURL =  URL(string: item["cover_xl"] as! String)
                    let mainImageData = NSData(contentsOf: mainImageURL!)
                    let mainImage = UIImage(data: mainImageData! as Data)
                    
                    if let artist = item["artist"] as? JSONStandard {
                        artistName =  artist["name"] as? String
                    }
                    let artista = (Artist.init(idFromAPI: idFromAPI!, name: artistName!, image: mainImage!))!
                    
                    addAlbum((Album.init(idFromAPI: idFromAPI!, name: albumTitle!, cover: mainImage!, artist: artista))!)
                    self.topAlbumsCollectionView.reloadInputViews()
                    self.topAlbumsCollectionView.reloadData()
                }
                
            }
        }
        catch{
            print(error)
        }
    }
    
    func parseDataTrack(JSONData : Data) {
        var mainImageArtist : UIImage?
        
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracksData = readableJSON["data"] as? [JSONStandard]{
                for i in 0..<tracksData.count{
                    let item = tracksData[i]
                    let title = item["title"] as! String
                    let duration = item["duration"] as! Int
                    let idFromAPI = item["id"] as! Int
                    
                    if let artist = item["artist"] as? JSONStandard {
                        artistName = artist["name"] as? String
                        let mainImageURLArtist =  URL(string: artist["picture"] as! String)
                        let mainImageDataArtist = NSData(contentsOf: mainImageURLArtist!)
                        mainImageArtist = UIImage(data: mainImageDataArtist! as Data)!
                    }
                    
                    let artistObject = Artist(idFromAPI: idFromAPI, name: artistName, image: mainImageArtist!)
                    
                    if let album = item["album"] as? JSONStandard{
                        let mainImageURL =  URL(string: album["cover_big"] as! String)
                        let mainImageData = NSData(contentsOf: mainImageURL!)
                        let cover = UIImage(data: mainImageData! as Data)!
                        
                        albumName = album["title"] as? String
                        albumID = album["id"] as? Int
                        
                        let album = Album.init(idFromAPI: albumID, name: albumName, cover: cover, artist: artistObject)
                        
                        let track = Track.init(idFromAPI: idFromAPI, title: title, duration: duration, image: mainImageArtist!)
                        track?.album = album
                        track?.artist = artistObject
                        
                        addTrack(track!)
                        self.topTracksCollectionView.reloadInputViews()
                        self.topTracksCollectionView.reloadData()
                    }
                }
                
            }
        }
        catch{
            print(error)
        }
    }
    
    fileprivate func addArtist(_ artist: Artist) {
        topArtists.append(artist)
    }
    fileprivate func addAlbum(_ album: Album) {
        topAlbums.append(album)
    }
    fileprivate func addTrack(_ track: Track) {
        topTracks.append(track)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "HomeToArtistSegue") {
            let vc = segue.destination as! ArtistDetailsViewController
            vc.artist = topArtists[artistIndex]
        }
        if(segue.identifier == "HomeToAlbumSegue") {
            let vc = segue.destination as! AlbumDetailsViewController
            vc.album = topAlbums[albumIndex]
        }
        if(segue.identifier == "HomeToTrackSegue") {
            let vc = segue.destination as! TrackDetailsViewController
            vc.track = topTracks[trackIndex]
        }
        
    }
    
}
