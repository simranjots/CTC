
import UIKit



class LoginOpitonViewController: UIViewController {
    
    var userObject: User!
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Theme.gradientColor1, colorTwo: Theme.gradientColor2)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appeared")
        signUpButton.loginButton()
        signInButton.loginButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("View did appeared")
        
        let dbHelper = DatabaseHelper()
        
        userObject = dbHelper.checkLoggedIn()
        if (userObject != nil){
            
            performSegue(withIdentifier: "loginOptionsToHome", sender: self)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "loginOptionsToHome":
            let tbvc = segue.destination as! UITabBarController
            let navvc = tbvc.viewControllers![0] as! UINavigationController
            let destination = navvc.viewControllers[0] as! HomeViewController
            
            destination.userObject = userObject
        default: break
            
        }
        
        
        
    }
    
    
    
}
