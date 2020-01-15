import UIKit
import os.log

class Track: NSObject, NSCoding, Codable {
    
    //MARK: Properties
    var name: String
    var artistName: String
    var image: UIImage?
    
    var imageURL: URL?
    
    //MARK: Initialization
    init?(name: String, artistName: String, image: UIImage?, imageURL: URL? = nil) {
        
        if name.isEmpty || artistName.isEmpty {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.artistName = artistName
        self.image = image
        self.imageURL = imageURL
    }
    
    struct PropertyKey {
        static let name = "name"
        static let artistName = "artistName"
        static let image = "image"
        static let imageURL = "imageURL"
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(artistName, forKey: PropertyKey.artistName)
        coder.encode(imageURL, forKey: PropertyKey.imageURL)
    }
    
    required convenience init?(coder: NSCoder) {
        
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name of the track", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let artistName = coder.decodeObject(forKey: PropertyKey.artistName) as? String else {
            os_log("Unable to decode the name of the track", log: OSLog.default, type: .debug)
            return nil
        }
        
        let image = coder.decodeObject(forKey: PropertyKey.image) as? UIImage
        
        let imageURL = coder.decodeObject(forKey: PropertyKey.imageURL) as? URL
        
        self.init(name: name, artistName: artistName, image: image, imageURL: imageURL)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case artistName
        case imageURL = "image"
    }
    
}
