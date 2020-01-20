import UIKit

class Track: NSObject {
    
    //MARK: Properties
    private var _idFromAPI: Int
    private var _title: String
    private var _duration: Int
    private var _album: Album?
    private var _artist: Artist?
    var image: UIImage

    
    var idFromAPI: Int {
        get {
            return _idFromAPI
        }
    }
    
    var title: String {
        get {
            return _title
        }
    }
    
    var duration: Int {
        get {
            return _duration
        }
    }
    
    var album: Album? {
        get {
            return _album
        }
        
        set (newAlbum){
            _album = newAlbum
        }
    }
    
    var artist: Artist? {
        get {
            return _artist
        }
        
        set (newArtist){
            _artist = newArtist
        }
    }
    
    //MARK: Initialization
    init?(idFromAPI: Int, title: String, duration: Int, image: UIImage) {
        
        if title.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self._idFromAPI = idFromAPI
        self._title = title
        self._duration = duration
        self.image = image
    }
}
