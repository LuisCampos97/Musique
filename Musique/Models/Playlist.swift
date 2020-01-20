import UIKit

class Playlist: NSObject {
    
    //MARK: Properties
    var idFromAPI: Int
    var name: String
    var cover: UIImage?
    var tracks: [Track]?
    
    //MARK: Initialization
    init?(idFromAPI: Int, name: String, cover: UIImage?) {
        self.idFromAPI = idFromAPI
        self.name = name
        self.cover = cover
    }
    
    func addTrack(track: Track) {
        tracks?.append(track)
    }
}
