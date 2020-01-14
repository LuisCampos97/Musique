import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        loginButton.color = UIColor(red:0.38, green:0.11, blue:0.11, alpha:1.0)
        
        //Validate Text Fields
        
        let email = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if (error != nil) {
                
                //Couldn't Sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                self.loginButton.color = UIColor(red:0.76, green:0.17, blue:0.18, alpha:1.0)
            }
            else {
                //Transition to HomeView
                self.performSegue(withIdentifier: "LoginToHomeSegue", sender: self)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
}
