import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var localtionLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var localization = String()
    var weather = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localtionLabel.text = localization
        weatherLabel.text = weather
    }
}
