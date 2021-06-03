import UIKit

class MorePageViewController: UIViewController {
    
    
    let moreOptionList = ["Practice History", "FAQ", "About Us", "How To Use The App", "Logout", ""]
    let moreOptionIconList = ["History", "FAQ", "Aboutus", "User-Manual", "Logout", ""]
    
    var dbHelper: DatabaseHelper!
    var userObject: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper = DatabaseHelper()
        userObject = dbHelper.checkLoggedIn()

    }
    



}

extension MorePageViewController : UITableViewDelegate, UITableViewDataSource{
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return moreOptionIconList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            
                        return 30
            
                    }
                    else{
            
                        return 10
            
                    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "morePageCell") as! MorePageTableViewCell
        
        cell.optionIconImageView.image = UIImage(named: moreOptionIconList[indexPath.row + indexPath.section])
        cell.optionLabel.text = moreOptionList[indexPath.row + indexPath.section]
        
        print(moreOptionList.endIndex)
        print(indexPath.section)
        
        if moreOptionList.endIndex-1 == indexPath.section{
            
            cell.accessoryType = .none
            
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("section : \(indexPath.section)")
        print(moreOptionIconList.count-1)
        print(moreOptionList[indexPath.section])
        switch moreOptionList[indexPath.section] {
        case "Practice History":
            performSegue(withIdentifier: "moreToHistorySegue", sender: self)
            break
        case "FAQ":
            performSegue(withIdentifier: "moreOptionToFAQ", sender: self)
            break
        case "E-Books":
            break
        case "About Us":
            performSegue(withIdentifier: "moreToAboutUs", sender: self)
            break
        case "Help":
            break
        case "Logout":
            if(userObject != nil){
                
                var resultFlag = dbHelper.updateLoginStatus(status: false, email: (userObject?.email)!)
                if (resultFlag == 0){
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "newLoginOptions") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                   

                }else{
                    
                    showAlert(title: "Error", message: "Failed to update login status try again", buttonTitle: "Try Again")
                    
                }
                
            }else{
                
                showAlert(title: "Error", message: "User not found. . .", buttonTitle: "Try Again")
                
            }
            break
            
        default:
            break
        }
        
        
        
        if indexPath.section == moreOptionIconList.count-2{
            
           
            
            
            
            
        }
        
    }
    
    
    
    
}
