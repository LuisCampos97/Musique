import UIKit
import Alamofire

class AlbumDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var album: Album!
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    typealias JSONStandard = [String : AnyObject]
    
    var tracks = [Track]()
    
    var artist : Artist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://api.deezer.com/album/\(String(album.idFromAPI))"
        
        albumCover.image = album.cover
        albumTitle.text = album.name
        
        AF.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            //MARK: Get artist from album
            if let artistObjectFromAPI = readableJSON["artist"] as? JSONStandard {
                let artistIdFomAPI = artistObjectFromAPI["id"] as! Int
                let artistNameFromAPI = artistObjectFromAPI["name"] as! String
                
                let mainImageURLArtist =  URL(string: artistObjectFromAPI["picture_big"] as! String)
                let mainImageDataArtist = NSData(contentsOf: mainImageURLArtist!)
                let artistImageFromAPI = UIImage(data: mainImageDataArtist! as Data)!
                
                artist = Artist(idFromAPI: artistIdFomAPI, name: artistNameFromAPI, image: artistImageFromAPI)!
            }
            
            //MARK:  Get tracks from album
            if let tracskObjectFromAPI = readableJSON["tracks"] as? JSONStandard {
                if let tracksData = tracskObjectFromAPI["data"] as? [JSONStandard]{
                        for i in 0..<tracksData.count{
                            let item = tracksData[i]
                            let idFromAPI = item["id"] as! Int
                            let title = item["title"] as! String
                            let duration = item["duration"] as! Int
                            
                            let track = Track(idFromAPI: idFromAPI, title: title, duration: duration, image: artist.image)
                            track?.album = album
                            track?.artist = artist
                            
                            addTrack(track!)
                            self.tableView.reloadData()
                    }
                    
                }
            }
            
        }
        catch{
            print(error)
        }
    }
    
    fileprivate func addTrack(_ track: Track) {
        let newIndexPath = IndexPath(row: tracks.count, section: 0)
        tracks.append(track)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    //MARK: Table View data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackAlbumCell", for: indexPath) as? AlbumDetailsTableViewCell
        
        let track = tracks[indexPath.row]
        cell?.trackTitle.text = track.title
        cell?.trackDuration.text = Utils.timeString(numberToConvert: track.duration)
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! TrackDetailsViewController
        vc.track = tracks[indexPath!]
    }
}
