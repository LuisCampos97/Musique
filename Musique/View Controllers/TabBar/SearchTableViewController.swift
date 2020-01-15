import UIKit
import Alamofire
import os.log

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var artistName : String!
    
    var searchURL = String()
    
    var tracks = [Track]()
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //tracks.removeAll()
        
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchURL = "https://api.deezer.com/search?q=\(finalKeywords!)&limit=7"
        
        print(searchURL)
        
        callDeezerAPI(url: searchURL)
        
        self.view.endEditing(true)
    }
    
    func callDeezerAPI(url: String) {
        
        AF.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracksData = readableJSON["data"] as? [JSONStandard]{
                    for i in 0..<tracksData.count{
                        let item = tracksData[i]
                        print(item)
                        let name = item["title"] as! String
                        
                        if let artist = item["artist"] as? JSONStandard {
                            artistName = artist["name"] as! String
                        }
                        
                        if let album = item["album"] as? JSONStandard{
                            let mainImageURL =  URL(string: album["cover"] as! String)
                            let mainImageData = NSData(contentsOf: mainImageURL!)
                                
                            let mainImage = UIImage(data: mainImageData! as Data)
                                
                            addTrack((Track.init(name: name, artistName: artistName, image: mainImage))!)
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
        
        cell.nameLabel.text = track.name
        cell.artistNameLabel.text = track.artistName
        cell.albumImage.image = track.image
        
        return cell
    }
}
