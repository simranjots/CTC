import UIKit

class MaintabBarViewController: UITabBarController, UITabBarControllerDelegate {

//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.delegate = self
        self.selectedIndex = 0
        setupMiddleButton()
    }
    func setupMiddleButton() {
        
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 25, y: -20, width: 60, height: 60))
        
        middleButton.setBackgroundImage(UIImage(named: "plus"), for: .normal)
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        middleButton.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    
        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        self.selectedIndex = 2
        print("Tapped")
    }


}
