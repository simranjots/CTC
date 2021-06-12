import UIKit

class MorePageViewController: UIViewController {
    
    //TableView outlet
    @IBOutlet var moreVCTableView: UITableView!
    
    //Array of more options and icons
    let moreOptionsList = ["Practice History", "How to Use App", "About Program", "Frequently Asked Questions", "Join Facebook Community", "Privacy Policy", "Order Books", "About Authors", "Connect To Us", "Log Out"]
    
    let moreOptionIcons = ["practiceHistory", "howToUseApp", "aboutProgram", "FAQs", "joinFacebookCommunity", "privacyPolicy", "orderBooks", "aboutAuthors", "connectToUs", "logOut"]
    
    var currentUser: CurrentUser!
    var userObject: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        moreVCTableView.delegate = self
        moreVCTableView.dataSource = self
        
        currentUser = CurrentUser()
        userObject = currentUser.checkLoggedIn()
    }
}


//MARK:- Extention for tableView

extension MorePageViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreOptionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.moreVCTableViewCell) as! MorePageTableViewCell
        
        cell.optionLabel.text = moreOptionsList[indexPath.row]
        cell.optionIconImageView.image = UIImage(named: moreOptionIcons[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch moreOptionIcons[indexPath.row] {
        
        case "practiceHistory":
            performSegue(withIdentifier: Constants.Segues.moreToPracticeHistorySegue, sender: self)
            break
        
        case "howToUseApp":
            performSegue(withIdentifier: Constants.Segues.moreToHowToUseSegue, sender: self)
            break
            
        case "aboutProgram":
            performSegue(withIdentifier: Constants.Segues.moreToAboutProgramSegue, sender: self)
            break
            
        case "FAQs":
            performSegue(withIdentifier: Constants.Segues.moreToFAQsSegue, sender: self)
            break
            
        case "joinFacebookCommunity":
            UIApplication.shared.open(URL(string: "https://www.facebook.com")!, options: [:], completionHandler: nil)
            break
            
        case "privacyPolicy":
            performSegue(withIdentifier: Constants.Segues.moreToPrivacyPolicySegue, sender: self)
            break
            
        case "orderBooks":
            performSegue(withIdentifier: Constants.Segues.moreToOrderBooksSegue, sender: self)
            break
            
        case "aboutAuthors":
            performSegue(withIdentifier: Constants.Segues.moreToAboutAuthorsSegue, sender: self)
            break
            
        case "connectToUs":
            performSegue(withIdentifier: Constants.Segues.moreToConnectToUsSegue, sender: self)
            break
            
        case "logOut":
            if (userObject != nil) {
                
                let resultFlag = currentUser.updateLoginStatus(status: false, email: (userObject?.email)!)
                
                if (resultFlag == 0) {
                    
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "newLoginOptions") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                    
                } else {
                    showAlert(title: "Error!", message: "Failed to update login status.", buttonTitle: "Try Again")
                }
            } else {
                showAlert(title: "Error!", message: "There's problem in loging out.", buttonTitle: "Try Again")
            }
            break
            
        default:
            print("Screen is not available.")
            break
        }
    }
}
