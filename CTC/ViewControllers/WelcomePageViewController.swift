

import UIKit

class WelcomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images : [String] = ["FinalLogo","1.jpeg", "2", "3", "4", "FinalLogo"]
    var descriptionLabelText = ["","Add Your Practices by Tapping on Add Button with + Icon", "Review Your Percentages and Add Notes Here","Edit or Delete old Practices","Review Your Track Record",""]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0 )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        onboardingCollectionView.showsVerticalScrollIndicator = false
        onboardingCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    @IBAction func signup(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        dismiss(animated: true, completion: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath)
        if(indexPath.row == images.startIndex){
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath)
            return cell
            
        }else if(indexPath.row == images.endIndex-1){
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "endCell", for: indexPath)
            return cell
            
        }else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "middleCell", for: indexPath) as! OnboardingMiddleCell
            
            cell.imageView.image = UIImage(named: images[indexPath.row])
            cell.descriptionLabel.text = descriptionLabelText[indexPath.row]
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        let pageNo = x / view.frame.width
        
        pageControl.currentPage = Int(pageNo)
        
    }
    
    
}
