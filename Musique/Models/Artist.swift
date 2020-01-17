import UIKit

class Artist: NSObject {
    
    //MARK: Properties
    var idFromAPI: Int = 0
    var name: String
    var image: UIImage
    
    //MARK: Initialization
    init?(idFromAPI: Int, name: String, image: UIImage) {
        self.idFromAPI = idFromAPI
        self.name = name
        self.image = image
    }
}
