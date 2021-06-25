import UIKit

class MaintabBarViewController: UITabBarController, UITabBarControllerDelegate {

//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.delegate = self
        self.selectedIndex = 2
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 35, y: -30, width: 80, height: 80))
        
        middleButton.setBackgroundImage(UIImage(named: "home-2"), for: .normal)
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        //middleButton.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    
        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func homeButtonTapped(sender: UIButton) {
        self.selectedIndex = 2
    }
}
