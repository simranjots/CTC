import UIKit

class OnBoardingVC: UIViewController {

    
    //MARK: - Outlets
    
    @IBOutlet var onBoardingCollectionView: UICollectionView!
    @IBOutlet var doneButtonOutlet: UIButton!
    //MARK: - Images and Descriptions
    
    let snapshotImages = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var currentUser : CurrentUser!
    var userObject: User!
    let db = FirebaseDataManager()
    var selectedDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        onBoardingCollectionView.delegate = self
        onBoardingCollectionView.dataSource = self
        Utilities.styleButton(doneButtonOutlet)
        
        currentUser = CurrentUser()
        userObject = currentUser.checkLoggedIn()
        selectedDate = Date().dateFormate()!
        var pUid : String?
            db.FetchPractices(puid: userObject.uid!, completion: { [self](value,pid) -> Void in
                if value == true {
                    pUid = pid
                    if pUid != nil {
                        db.FetchPracData(uid: pUid!, docid: userObject.uid!,completionhandler: { (flag) in
                            if flag == true{
                                UserDefaults.standard.set(true, forKey: "weekly")
                            }
                        })
                    }
                }
            })
          
           
        
        
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
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
        
        cell.appSnapshotsImageView.image = UIImage(named: "\(snapshotImages[indexPath.row]).jpg")
        
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
