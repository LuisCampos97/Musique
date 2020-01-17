import UIKit
import Alamofire

class AlbumDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var album: Album!
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    typealias JSONStandard = [String : AnyObject]
    
    var tracks = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://api.deezer.com/album/\(String(album.idFromAPI))/tracks"
        print(url)
        
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
            print(readableJSON)
            if let tracksData = readableJSON["data"] as? [JSONStandard]{
                    for i in 0..<tracksData.count{
                        let item = tracksData[i]
                        let idFromAPI = item["id"] as! Int
                        let title = item["title"] as! String
                        let duration = item["duration"] as! Int
                        
                        let track = Track(idFromAPI: idFromAPI, title: title, duration: duration)
                        
                        addTrack(track!)
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
    
    
    //MARK: Table View data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackAlbumCell", for: indexPath)
        
        let track = tracks[indexPath.row]
        cell.textLabel!.text = track.title
        
        return cell
        
    }
}
