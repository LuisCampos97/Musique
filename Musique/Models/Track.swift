import UIKit
import os.log

class Track: NSObject {
    
    //MARK: Properties
    private var _idFromAPI: Int
    private var _title: String
    private var _duration: Int
    private var _album: Album?
    private var _artist: Artist?
    
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
    init?(idFromAPI: Int, title: String, duration: Int) {
        
        if title.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self._idFromAPI = idFromAPI
        self._title = title
        self._duration = duration
    }
    
//    struct PropertyKey {
//        static let idFromAPI = "idFromAPI"
//        static let title = "title"
//        static let duration = "duration"
//        //static let album = "album"
//        //static let artist = "artist"
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(idFromAPI, forKey: PropertyKey.idFromAPI)
//        coder.encode(title, forKey: PropertyKey.title)
//        coder.encode(duration, forKey: PropertyKey.duration)
//        //coder.encode(albumName, forKey: PropertyKey.albumName)
//    }
//
//    required convenience init?(coder: NSCoder) {
//
//        guard let idFromAPI = coder.decodeObject(forKey: PropertyKey.idFromAPI) as? Int else {
//            os_log("Unable to decode the id of the track", log: OSLog.default, type: .debug)
//            return nil
//        }
//
//        guard let title = coder.decodeObject(forKey: PropertyKey.title) as? String else {
//            os_log("Unable to decode the name of the track", log: OSLog.default, type: .debug)
//            return nil
//        }
//
//        guard let duration = coder.decodeObject(forKey: PropertyKey.duration) as? Int else {
//            os_log("Unable to decode the duration of the track", log: OSLog.default, type: .debug)
//            return nil
//        }
//
//        self.init(idFromAPI: idFromAPI, title: title, duration: duration)
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case idFromAPI
//        case title
//        case duration
//    }
    
}
