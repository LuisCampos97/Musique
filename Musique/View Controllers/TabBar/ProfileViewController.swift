import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logoutPressed(_ sender: Any) {
        AppManager.shared.logout()
    }
}
