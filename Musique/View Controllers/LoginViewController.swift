import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        loginButton.color = UIColor.black
        
        //Validate Text Fields
        
        let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if (error != nil) {
                
                //Couldn't Sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                //Transition to HomeView
                self.performSegue(withIdentifier: "LoginToHomeSegue", sender: self)
            }
        }
    }
}
