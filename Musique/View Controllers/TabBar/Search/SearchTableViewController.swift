import UIKit
import Alamofire
import os.log

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var artistName : String!
    var albumName : String!
    var albumID : Int!
    
    var searchURLTrack = String()
    var searchURLArtist = String()
    
    var mainImageArtist : UIImage?
    
    var tracks = [Track]()
    var artists = [Artist]()
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        tracks.removeAll()
        tableView.reloadData()
        
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchURLTrack = "https://api.deezer.com/search/track?q=\(finalKeywords!)&limit=10"
        searchURLArtist = "https://api.deezer.com/search/artist?q=\(finalKeywords!)&limit=10"
        
        callDeezerTrackAPI(url: searchURLTrack)
        //callDeezerArtistAPI(url: searchURLArtist)
        
        self.view.endEditing(true)
    }
    
    func callDeezerTrackAPI(url: String) {
        
        AF.request(url).responseJSON(completionHandler: {
            response in
            self.parseDataTrack(JSONData: response.data!)
        })
    }
    
    func callDeezerArtistAPI(url: String) {
        
        AF.request(url).responseJSON(completionHandler: {
            response in
            self.parseDataArtist(JSONData: response.data!)
        })
    }
    
    func parseDataTrack(JSONData : Data) {
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
                            
                            let track = Track.init(idFromAPI: idFromAPI, title: title, duration: duration)
                            track?.album = album
                            track?.artist = artistObject
                            
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
    
    func parseDataArtist(JSONData : Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let artistsData = readableJSON["data"] as? [JSONStandard]{
                    for i in 0..<artistsData.count{
                        let artist = artistsData[i]
                        
                        let title = artist["name"] as! String
                        let idFromAPI = artist["id"] as! Int
                        
                        let mainImageURL =  URL(string: artist["picture_big"] as! String)
                        let mainImageData = NSData(contentsOf: mainImageURL!)
                        let picture = UIImage(data: mainImageData! as Data)!
                        
                        let artistObject = Artist(idFromAPI: idFromAPI, name: title, image: picture)
                        addArtist(artistObject!)
                        
                        self.tableView.reloadData()
        
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
    
    fileprivate func addArtist(_ artist: Artist) {
        let newIndexPath = IndexPath(row: artists.count, section: 0)
        artists.append(artist)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    //MARK: Table View data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "TrackCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrackTableViewCell else {
            fatalError("The dequeued cell is not an instance of TrackTableViewCell")
        }
        
        let track = tracks[indexPath.row]
        
        cell.nameLabel.text = track.title
        cell.artistNameLabel.text = track.artist?.name
        cell.albumImage.image = track.album?.cover
        
        return cell
    }
    
    //MARK: Send data to Track Details View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! TrackDetailsViewController
        vc.track = tracks[indexPath!]
    }
    
}
