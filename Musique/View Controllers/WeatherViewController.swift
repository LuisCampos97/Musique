import UIKit
import Alamofire

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var localtionLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    typealias JSONStandard = [String : AnyObject]
    
    var location = String()
    var weather = String()
    
    var tracks = [Track]()
    
    var artistName : String!
    var albumName : String!
    var albumID : Int!
    var mainImageArtist : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        localtionLabel.text = location
        weatherLabel.text = weather
        
        switch weather {
        case "Clear":
            callApi(url: "https://api.deezer.com/search/playlist?q=sunny")
        case "Clouds":
            callApi(url: "https://api.deezer.com/search/playlist?q=classic")
        default:
            print("DEFAULT")
        }
    }
    
    func parseDataPlaylist(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let playlistData = readableJSON["data"] as? [JSONStandard]{
                let playlist = playlistData[0]
                
                let idFromAPI = playlist["id"] as! Int
                let name = playlist["title"] as! String
                
                let mainImageURL =  URL(string: playlist["picture_big"] as! String)
                let mainImageData = NSData(contentsOf: mainImageURL!)
                let cover = UIImage(data: mainImageData! as Data)!
                
                let playlistObject = Playlist(idFromAPI: idFromAPI, name: name, cover: cover)
                
                playlistImage.image = playlistObject?.cover
                playlistName.text = playlistObject?.name
                
                AF.request("https://api.deezer.com/playlist/\(idFromAPI)/tracks").responseJSON(completionHandler: {
                    response in
                    self.parseDataTracks(JSONData: response.data!)
                })
            }
        }
        catch{
            print(error)
        }
    }
    
    func parseDataTracks(JSONData: Data) {
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
                            
                            let track = Track.init(idFromAPI: idFromAPI, title: title, duration: duration, image: cover)
                            track?.album = album
                            track?.artist = artistObject
                            
                            addTrack(track: track!)
                            self.tableView.reloadData()
                        }
                }
                
            }
        }
        catch{
            print(error)
        }
    }
    
    func addTrack(track: Track) {
        let newIndexPath = IndexPath(row: tracks.count, section: 0)
        tracks.append(track)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    //MARK: TableView data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTrackCell", for: indexPath) as? WeatherTracksTableViewCell
        
        let track = tracks[indexPath.row]
        cell?.trackName.text = track.title
        cell?.trackDuration.text = Utils.timeString(numberToConvert: track.duration)
        
        return cell!
    }
    
    func callApi(url: String) {
        AF.request(url).responseJSON(completionHandler: {
            response in
            self.parseDataPlaylist(JSONData: response.data!)
        })
    }
}
