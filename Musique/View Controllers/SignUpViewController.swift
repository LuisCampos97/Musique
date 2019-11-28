import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func validateFields() -> String? {
        
        //Check that all fields are fillen in
        if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordConfirmationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")  {
            
            return "Please fill in all fields"
        }
        
        //TODO: Check if the passowrd is secure
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //MARK: Next Button Click
    @IBAction func nextTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            
            // Transition to Agree View
            performSegue(withIdentifier: "SignUpToAgreeTermsSegue", sender: self)
        }
    }
    
    
    
    func passarParaAgree() {
        // Create clean variables
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            // Check for errors
            if error != nil {
                self.showError("Error creating User!")
            }
            else {
                
                // User was created successfuly: store the first name and last name
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(
                    data: ["name": name,
                           "email": email,
                           "uid": result!.user.uid]) { (error) in
                            
                            if error != nil {
                                self.showError("Error saving user data")
                            }
                }
            }
        }
    }
    
}
