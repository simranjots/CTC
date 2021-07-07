import UIKit

class PracticeHistoryViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var practiceHistoryCollectionView: UICollectionView!
    
    @IBOutlet var previousButtonOutlet: UIButton!
    @IBOutlet var nextButtonOutlet: UIButton!
    @IBOutlet var restoreButtonOutlet: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    
    var practiceHistory: PracticedHistory!
    var practice :UserPractices!
    var deletedHistory: [PracticeHistory] = []
    var currentUser : CurrentUser!
    var userObject: User!
    var noOfPages: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButtonOutlet.isHidden = true
        nextButtonOutlet.isHidden = true
        restoreButtonOutlet.isHidden = true
        pageControl.isHidden = true
        practiceHistoryCollectionView.delegate = self
        practiceHistoryCollectionView.dataSource = self
        addShadowToButtons()
        guard let restoreButtonIcon = UIImage(named: "restore-1") else { return }
        Utilities.addButtonImage(button: restoreButtonOutlet, andImage: restoreButtonIcon)
        Utilities.styleButton(restoreButtonOutlet)
        
        practiceHistory = PracticedHistory()
        practice = UserPractices()
        currentUser = CurrentUser()
        userObject = currentUser.checkLoggedIn()
        let history = practiceHistory.getPracticeHistory(userobject: userObject)
        if(history?.count != 0){
            
            for data in history!{
                deletedHistory.append(data)
            }
            noOfPages = deletedHistory.count
            pageControl.numberOfPages = deletedHistory.count
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshTableView()
    }
    func refreshTableView() {
     
        deletedHistory = []
        
        let history = practiceHistory.getPracticeHistory(userobject: userObject)
       
        if(history?.count != 0){
            
            for data in history!{
                deletedHistory.append(data)
            }
            noOfPages = deletedHistory.count
            pageControl.numberOfPages = deletedHistory.count
        }
        self.practiceHistoryCollectionView.reloadData()
    }
    
    //MARK: - IBActions
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        pageControl.currentPage = prevIndex
        practiceHistoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        let pracName =  deletedHistory[pageControl.currentPage].practice_name!
        let date =  Date().dateFormate()
        let encourage = "Think of the good future"
        let repeatpracName  = practice.getPractices(practiceName: pracName, user: userObject)
        if pracName == repeatpracName?.practice {
            showAlert(title: "Warning", message: "Can not add practice with same name  ", buttonTitle: "Try Again")
        }else{
            _=practice.addPractices(practice:pracName, image_name: "Flour", date: date! , user: userObject, value: "ACHIEVEMENT", encourage: encourage, remindswitch: false, goals: "365", practiceDay: 0)
        }
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let nextIndex = min(pageControl.currentPage + 1, noOfPages-1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        practiceHistoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //Style Buttons
    func addShadowToButtons() {
        Utilities.addShadowToButton(previousButtonOutlet)
        Utilities.addShadowToButton(nextButtonOutlet)
        Utilities.addShadowToButton(restoreButtonOutlet)
    }
}

//MARK: - Extension for UICollectionView

extension PracticeHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if deletedHistory.count > 0 {
            previousButtonOutlet.isHidden = false
            nextButtonOutlet.isHidden = false
            restoreButtonOutlet.isHidden = false
            pageControl.isHidden = false
        }
        return deletedHistory.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = practiceHistoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.practiceHistoryCollectionViewCell, for: indexPath) as! PracticeHistoryCollectionViewCell
        let history = deletedHistory[indexPath.item]
        let trackingDays = history.td
        let daySinceStarted = history.dss
        let percentage = (Float(trackingDays) / Float(daySinceStarted == 0 ? 1 : daySinceStarted)) * 100
        cell.practiceNameLabel.text = history.practice_name
        cell.dateLabel.text = "Completed On : \(((history.date!) as Date).dateFormateToString()!)"
        cell.scoreLabel.text = "Your Score was : \(Int(percentage))%"
        cell.percentageLabel.text = "\(Int(percentage))%"
        cell.trackingDaysLabel.text = "\(trackingDays)"
        cell.daysSinceStartedLabel.text = "\(daySinceStarted)"
        
        
        
        
        //Style CollectionView Elements
        Utilities.addShadowAndBorderToView(cell.histotyContainerView)
        cell.histotyContainerView.layer.borderColor = UIColor.white.cgColor
        cell.circularProgressBarView.trackColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.circularProgressBarView.progressColor = #colorLiteral(red: 0, green: 0.7097216845, blue: 0.6863465309, alpha: 1)
        cell.circularProgressBarView.setProgressWithAnimation(duration: 1.0, value: Float(Int(percentage)))
         
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / practiceHistoryCollectionView.frame.width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



