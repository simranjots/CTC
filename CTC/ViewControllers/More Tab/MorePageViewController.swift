import UIKit

class MorePageViewController: UIViewController {
    
    //MARK: - Top View elements
    let profileImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Teresa Easler")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let editButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleEditTap), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 22)
        label.text = "Teresa Easler"
        return label
    }()
    
    let emailLabel: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial", size: 18)
        label.text = "teresa.easler@gmail.com"
        return label
    }()
    
 
    
    //MARK: - Properties of top view elements
    
    lazy var containerView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Utilities.primaryTextColor
        
        view.addSubview(profileImageView)
        //profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 80, paddingLeft: 40, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        
        view.addSubview(editButton)
        editButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 200, paddingRight: 15, width: 20, height: 20)
        
        view.addSubview(nameLabel)
        //nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 110, paddingLeft: 180)
        
        view.addSubview(emailLabel)
        //emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.anchor(top:nameLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 5, paddingLeft: 180)
        
        return view
    }()
    
    //MARK:- TableView outlet
    @IBOutlet var moreVCTableView: UITableView!
    @IBOutlet var manualViewBelowContainerView: UIView!
    
    //MARK: - Array of more options and icons
    
    let moreOptionsList = ["How to Use App", "Join Facebook Community", "Frequently Asked Questions",  "About Authors", "Privacy Policy",  "Contact Us", "Sign Out"]
    
    let moreOptionIcons = ["howToUseApp", "joinFacebookCommunity", "FAQs", "aboutAuthors", "privacyPolicy",  "connectToUs-1", "logOut-1"]
    
    var currentUser: CurrentUser!
    var userObject: User?
    
    //MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        moreVCTableView.delegate = self
        moreVCTableView.dataSource = self
        
        currentUser = CurrentUser()
        userObject = currentUser.checkLoggedIn()
        
        //Set containerView above tableview
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        Utilities.addShadowAndBorderToView(containerView)
    
        //Set containerView bottom constraints
        moreVCTableView.anchor(top: containerView.bottomAnchor, paddingTop: 10)
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Selector
    
    @objc func handleEditTap() {
        performSegue(withIdentifier: Constants.Segues.moreToUpdateProfileSegue, sender: self)
    }
}


//MARK:- Extension for tableView

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
        
        switch moreOptionsList[indexPath.row] {
    
        case "How to Use App":
            performSegue(withIdentifier: Constants.Segues.moreToHowToUseSegue, sender: self)
            break
            
        case "Join Facebook Community":
            UIApplication.shared.open(URL(string: "https://www.facebook.com/groups/375234539714492/")!, options: [:], completionHandler: nil)
            break
            
        case "Frequently Asked Questions":
            performSegue(withIdentifier: Constants.Segues.moreToFAQsSegue, sender: self)
            break
            
        case "About Authors":
            performSegue(withIdentifier: Constants.Segues.moreToAboutAuthorsSegue, sender: self)
            break
            
        case "Privacy Policy":
            performSegue(withIdentifier: Constants.Segues.moreToPrivacyPolicySegue, sender: self)
            break
            
        case "Contact Us":
            performSegue(withIdentifier: Constants.Segues.moreToContactUsSegue, sender: self)
            break
            
        case "Sign Out":
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


//MARK: - Extension for UIView

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
                
    }
}


