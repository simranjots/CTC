import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var tagLineLabel: UILabel!
    
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
        setUpElements()
        
    }
    
    
    func setUpElements() {
        
        tagLineLabel.text = ""
        var charIndex = 0.0
        let taglineText = "Turn your wants into haves"
        
        for letters in taglineText {
            
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.tagLineLabel.text?.append(letters)
            }
            charIndex += 1
        }
        
        //Style Buttons
        Utilities.styleButton(loginButton)
        Utilities.styleHollowButton(registerButton)
        //Utilities.addShadowToButton(loginButton)
    }
    
}
