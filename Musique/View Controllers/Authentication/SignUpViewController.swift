import UIKit


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var genderPicker: UISegmentedControl!
    
    let datePicker = UIDatePicker()
    
    var name = ""
    var email = ""
    var password = ""
    var birthDate = ""
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        birthDateTextField.inputAccessoryView = toolbar
    }
    
    //Done button of Toolbar
    @objc func doneAction() {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        birthDateTextField.text = formatter.string(from: datePicker.date)
    }
    
    func validateFields() -> String? {
        
        //Check that all fields are fillen in
        if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordConfirmationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            birthDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")  {
            
            return "Please fill in all fields"
        }
        else {
            if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != passwordConfirmationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                
                return "Password and Password confirmation must be the same!"
            }
        }
        
        //TODO: Check if the password is secure
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //MARK: Next Button Click
    @IBAction func nextTapped(_ sender: Any) {
        
        // Create clean variables
        name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        gender = genderPicker.titleForSegment(at: genderPicker.selectedSegmentIndex) ?? "Not defined"
        birthDate = birthDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AgreeTermsViewController
        vc.name = self.name
        vc.email = self.email
        vc.password = self.password
        vc.gender = self.gender
        vc.birthDate = self.birthDate
    }
    
}
