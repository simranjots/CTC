import UIKit

class OnBoardingVC: UIViewController {

    
    //MARK: - Outlets
    
    @IBOutlet var onBoardingCollectionView: UICollectionView!
    @IBOutlet var nextButtonOutlet: UIButton!
    //MARK: - Images and Descriptions
    
    let snapshotImages = ["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg", "6.jpg", "7.jpg", "8.jpg", "9.jpg", "10.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        onBoardingCollectionView.delegate = self
        onBoardingCollectionView.dataSource = self
        Utilities.styleButton(nextButtonOutlet)
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
//        let nextIndex = min(snapshotImages.count, snapshotImages.count-1)
//        let indexPath = IndexPath(item: nextIndex, section: 0)
//        onBoardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        performSegue(withIdentifier: Constants.Segues.signInToHomeSegue, sender: self)
        
    }
}

//MARK: - Extension for collectionView

extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snapshotImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onBoardingCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.howToUseCollectionViewCell, for: indexPath) as! HowToUseCollectionViewCell
        
        cell.appSnapshotsImageView.image = UIImage(named: snapshotImages[indexPath.row])
        
        //Style appSnapshotImageView
        cell.appSnapshotsImageView.layer.cornerRadius = cell.appSnapshotsImageView.frame.height / 25
        cell.appSnapshotsImageView.layer.shadowColor = UIColor.black.cgColor
        cell.appSnapshotsImageView.layer.shadowOpacity = 0.5
        cell.appSnapshotsImageView.layer.shadowOffset = CGSize(width: 0.0, height: 1.7)
        
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
}
