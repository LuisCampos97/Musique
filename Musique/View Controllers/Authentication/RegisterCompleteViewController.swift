import UIKit
import FirebaseAuth
import Firebase
import Alamofire
import os.log

class RegisterCompleteViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var name = ""
    var email = ""
    var password = ""
    var gender = ""
    var birthDate = ""
    var _selectedCells : NSMutableArray = []
    
    var error: Error?
    
    let attributedString = String("\nThese terms and conditions (\"Terms\", \"Agreement\") are an agreement between Mobile Application Developer (\"Mobile Application Developer\", \"us\", \"we\" or \"our\") and you (\"User\", \"you\" or \"your\"). This Agreement sets forth the general terms and conditions of your use of the Musique mobile application and any of its products or services (collectively, \"Mobile Application\" or \"Services\").\n\nAccounts and membership\n\nIf you create an account in the Mobile Application, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may, but have no obligation to, monitor and review new accounts before you may sign in and use our Services. Providing false contact information of any kind may result in the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred as a result of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this Agreement or that your conduct or content would tend to damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration.\n\nBackups\n\nWe are not responsible for Content residing in the Mobile Application. In no event shall we be held liable for any loss of any Content. It is your sole responsibility to maintain appropriate backup of your Content. Notwithstanding the foregoing, on some occasions and in certain circumstances, with absolutely no obligation, we may be able to restore some or all of your data that has been deleted as of a certain date and time when we may have backed up data for our own purposes. We make no guarantee that the data you need will be available.\n\nLinks to other mobile applications\n\nAlthough this Mobile Application may link to other mobile applications, we are not, directly or indirectly, implying any approval, association, sponsorship, endorsement, or affiliation with any linked mobile application, unless specifically stated herein. Some of the links in the Mobile Application may be \"affiliate links\". This means if you click on the link and purchase an item, Mobile Application Developer will receive an affiliate commission. We are not responsible for examining or evaluating, and we do not warrant the offerings of, any businesses or individuals or the content of their mobile applications. We do not assume any responsibility or liability for the actions, products, services, and content of any other third-parties. You should carefully review the legal statements and other conditions of use of any mobile application which you access through a link from this Mobile Application. Your linking to any other off-site mobile applications is at your own risk.\n\nProhibited uses\n\nIn addition to other terms as set forth in the Agreement, you are prohibited from using the Mobile Application or its Content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Service or of any related mobile application, other mobile applications, or the Internet; (h) to collect or track the personal information of others; (i) to spam, phish, pharm, pretext, spider, crawl, or scrape; (j) for any obscene or immoral purpose; or (k) to interfere with or circumvent the security features of the Service or any related mobile application, other mobile applications, or the Internet. We reserve the right to terminate your use of the Service or any related mobile application for violating any of the prohibited uses.\n\nIntellectual property rights\n\nThis Agreement does not transfer to you any intellectual property owned by Mobile Application Developer or third-parties, and all rights, titles, and interests in and to such property will remain (as between the parties) solely with Mobile Application Developer. All trademarks, service marks, graphics and logos used in connection with our Mobile Application or Services, are trademarks or registered trademarks of Mobile Application Developer or Mobile Application Developer licensors. Other trademarks, service marks, graphics and logos used in connection with our Mobile Application or Services may be the trademarks of other third-parties. Your use of our Mobile Application and Services grants you no right or license to reproduce or otherwise use any Mobile Application Developer or third-party trademarks.\n\nLimitation of liability\n\nTo the fullest extent permitted by applicable law, in no event will Mobile Application Developer, its affiliates, officers, directors, employees, agents, suppliers or licensors be liable to any person for (a): any indirect, incidental, special, punitive, cover or consequential damages (including, without limitation, damages for lost profits, revenue, sales, goodwill, use of content, impact on business, business interruption, loss of anticipated savings, loss of business opportunity) however caused, under any theory of liability, including, without limitation, contract, tort, warranty, breach of statutory duty, negligence or otherwise, even if Mobile Application Developer has been advised as to the possibility of such damages or could have foreseen such damages. To the maximum extent permitted by applicable law, the aggregate liability of Mobile Application Developer and its affiliates, officers, employees, agents, suppliers and licensors, relating to the services will be limited to an amount greater of one dollar or any amounts actually paid in cash by you to Mobile Application Developer for the prior one month period prior to the first event or occurrence giving rise to such liability. The limitations and exclusions also apply if this remedy does not fully compensate you for any losses or fails of its essential purpose.\n\nIndemnification\n\nYou agree to indemnify and hold Mobile Application Developer and its affiliates, directors, officers, employees, and agents harmless from and against any liabilities, losses, damages or costs, including reasonable attorneys' fees, incurred in connection with or arising from any third-party allegations, claims, actions, disputes, or demands asserted against any of them as a result of or relating to your Content, your use of the Mobile Application or Services or any willful misconduct on your part.\n\nSeverability\n\nAll rights and restrictions contained in this Agreement may be exercised and shall be applicable and binding only to the extent that they do not violate any applicable laws and are intended to be limited to the extent necessary so that they will not render this Agreement illegal, invalid or unenforceable. If any provision or portion of any provision of this Agreement shall be held to be illegal, invalid or unenforceable by a court of competent jurisdiction, it is the intention of the parties that the remaining provisions or portions thereof shall constitute their agreement with respect to the subject matter hereof, and all such remaining provisions or portions thereof shall remain in full force and effect.\n\nDispute resolution\n\nThe formation, interpretation, and performance of this Agreement and any disputes arising out of it shall be governed by the substantive and procedural laws of Portugal without regard to its rules on conflicts or choice of law and, to the extent applicable, the laws of Portugal. The exclusive jurisdiction and venue for actions related to the subject matter hereof shall be the state and federal courts located in Portugal, and you hereby submit to the personal jurisdiction of such courts. You hereby waive any right to a jury trial in any proceeding arising out of or related to this Agreement. The United Nations Convention on Contracts for the International Sale of Goods does not apply to this Agreement.\n\nChanges and amendments\n\nWe reserve the right to modify this Agreement or its policies relating to the Mobile Application or Services at any time, effective upon posting of an updated version of this Agreement in the Mobile Application. When we do, we will send you an email to notify you. Continued use of the Mobile Application after any such changes shall constitute your consent to such changes. Policy was created with https://www.WebsitePolicies.com\n\nAcceptance of these terms\n\nYou acknowledge that you have read this Agreement and agree to all its terms and conditions. By using the Mobile Application or its Services you agree to be bound by this Agreement. If you do not agree to abide by the terms of this Agreement, you are not authorized to use or access the Mobile Application and its Services.\n\nContacting us\n\nIf you would like to contact us to understand more about this Agreement or wish to contact us concerning any matter relating to it, you may send an email to musique.meicm@gmail.com\n\nThis document was last updated on January 16, 2020\n")

    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in

            // Check for errors
            if error != nil {
                self.error = error
                self.showError("Error creating User!")
            }
            else {

                // User was created successfuly: store the data of user
                let db = Firestore.firestore()
                
                switch self._selectedCells.count {
                case 1:
                    db.collection("users").document(result!.user.uid).setData(
                        ["name": self.name,
                               "email": self.email,
                               "gender": self.gender,
                               "birthDate": self.birthDate,
                               "favouriteArtists":[self._selectedCells[0]],
                        "uid": result!.user.uid]) { (error) in
                                if error != nil {
                                    self.error = error
                                    self.showError("Error saving user data")
                                }
                    }
                case 2:
                    db.collection("users").document(result!.user.uid).setData(
                            ["name": self.name,
                               "email": self.email,
                               "gender": self.gender,
                               "birthDate": self.birthDate,
                               "favouriteArtists":[self._selectedCells[0], self._selectedCells[1]],
                               "uid": result!.user.uid]) { (error) in
                                if error != nil {
                                    self.error = error
                                    self.showError("Error saving user data")
                                }
                    }
                case 3:
                    db.collection("users").document(result!.user.uid).setData(
                            ["name": self.name,
                               "email": self.email,
                               "gender": self.gender,
                               "birthDate": self.birthDate,
                               "favouriteArtists":[self._selectedCells[0], self._selectedCells[1], self._selectedCells[2]],
                               "uid": result!.user.uid]) { (error) in
                                if error != nil {
                                    self.error = error
                                    self.showError("Error saving user data")
                                }
                    }
                default:
                    db.collection("users").document(result!.user.uid).setData(
                            ["name": self.name,
                               "email": self.email,
                               "gender": self.gender,
                               "birthDate": self.birthDate,
                               "uid": result!.user.uid]) { (error) in
                                if error != nil {
                                    self.error = error
                                    self.showError("Error saving user data")
                                }
                    }
                }
                
                

            }
        }
        
        
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        
        if(self.error != nil) {
            self.showError("Error creating User!")

        }else{
            
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
                if (error != nil) {
                    //Couldn't Sign in
                    self.showError("Unable to sign in")
                }
                else {
                    //Transition to HomeView
                    self.performSegue(withIdentifier: "SignUpToDashboardSegue", sender: self)
                }
            }
            
            
        }
    
    }
    
    
    
    @IBAction func reviewTermsTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Terms & Conditions", message: attributedString, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
