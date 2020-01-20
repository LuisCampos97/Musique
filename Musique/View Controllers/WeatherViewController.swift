import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var localtionLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var location = String()
    var weather = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localtionLabel.text = location
        weatherLabel.text = weather
    }
}
