import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var appContainer: AppContainerViewController!
    
    private init() {
        
    }
    
    func showApp() {
        
        var viewController: UIViewController
        
        if Auth.auth().currentUser == nil {
            viewController = storyboard.instantiateViewController(identifier: "ViewController")
        } else {
            viewController = storyboard.instantiateViewController(identifier: "TabBarController")
        }
        
        appContainer.present(viewController, animated: true, completion: nil)
    }
    
    func logout() {
        try! Auth.auth().signOut()
        appContainer.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
