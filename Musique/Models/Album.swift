import UIKit

class Album: NSObject {
    
    //MARK: Properties
    var idFromAPI: Int
    var name: String
    var cover: UIImage?
    var artist: Artist?
    var tracks: [Track]?
    
    //MARK: Initialization
    init?(idFromAPI: Int, name: String, cover: UIImage?, artist: Artist?) {
        self.idFromAPI = idFromAPI
        self.name = name
        self.cover = cover
    }
    
    func addTrack(track: Track) {
        tracks?.append(track)
    }
}
