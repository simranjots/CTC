import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.isNavigationBarHidden = true
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         navigationController?.isNavigationBarHidden = false
     }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleButton(loginButton)
        Utilities.styleButton(registerButton)

    }
    
}
