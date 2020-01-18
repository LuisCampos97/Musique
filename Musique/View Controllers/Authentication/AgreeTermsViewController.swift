import UIKit
import FirebaseAuth
import Firebase
import Alamofire
import os.log

class AgreeTermsViewController: UIViewController {
    
    
    @IBOutlet weak var agreeSwitch: UISwitch!
    @IBOutlet weak var signUpButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var name = ""
    var email = ""
    var password = ""
    var gender = ""
    var birthDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(gender)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        if(agreeSwitch.isOn) {
                    
            //Transition to the view of Select 3 favorities artists
            self.performSegue(withIdentifier: "AgreeTermsToFavouriteArtistsSegue", sender: self)

        }
        else {
            self.showError("You must agree with terms to continue the register!")
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SelectFavouriteArtistsViewController
        vc.name = self.name
        vc.email = self.email
        vc.password = self.password
        vc.gender = self.gender
        vc.birthDate = self.birthDate
    }
    
}
