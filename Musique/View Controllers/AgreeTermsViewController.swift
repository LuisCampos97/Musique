import UIKit
import FirebaseAuth
import Firebase

class AgreeTermsViewController: UIViewController {
    
    
    @IBOutlet weak var agreeSwitch: UISwitch!
    @IBOutlet weak var signUpButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var name = ""
    var email = ""
    var password = ""
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(gender)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        if(agreeSwitch.isOn) {
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                // Check for errors
                if error != nil {
                    self.showError("Error creating User!")
                }
                else {
                    
                    // User was created successfuly: store the data of user
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(
                        data: ["name": self.name,
                               "email": self.email,
                               "gender": self.gender,
                               "uid": result!.user.uid]) { (error) in
                                
                                if error != nil {
                                    self.showError("Error saving user data")
                                }
                    }
                }
            }
        }
        else {
            self.showError("You must agree with terms to continue the register!")
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
