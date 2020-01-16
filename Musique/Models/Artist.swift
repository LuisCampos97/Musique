import UIKit

class Artist: NSObject {
    
    var idFromAPI: Int = 0
    var name: String
    
    init?(idFromAPI: Int, name: String) {
        self.idFromAPI = idFromAPI
        self.name = name
    }
}
