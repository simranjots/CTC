
import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    var userObject : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var currentUser = CurrentUser()
        
        userObject = currentUser.checkLoggedIn()
        
        if (userObject != nil){
        
            
            perform( #selector(MainNavigationController.showHome), with: nil, afterDelay: 0.01 )
            
        }else{
            
            perform(#selector(MainNavigationController.showLogin), with: nil, afterDelay: 0.01)
        }
        
    }
    
    @objc func showHome() {
        
        let homeController = MaintabBarViewController()
        
        present(homeController, animated: true, completion: {
            
        })
        
        
    }
    @objc func showLogin() {
        let login = LoginOpitonViewController()
        present(login, animated: true, completion: {
            
        })
    }
}
