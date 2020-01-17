import UIKit

class Utils {
    
    //MARK: Function to convert a number in seconds to a time (minute:seconds)
    static func timeString(numberToConvert: Int) -> String {
        let minute = Int(numberToConvert) / 60 % 60
        let second = Int(numberToConvert) % 60

        return String(format: "%02i:%02i", minute, second)
    }
}
