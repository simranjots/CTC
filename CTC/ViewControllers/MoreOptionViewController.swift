import UIKit

class MoreOptionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var moreOptionCollectionView: UICollectionView!
    
   
    let moreOptionList = ["Practices History", "Edit Practice", "FAQ", "E-Books", "About Us", "Help", ]
    let moreOptionIconList = ["Home", "Profile", "More","Home", "Profile", "More"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        print(UIScreen.main.bounds.width / 3)
        let itemSize = (UIScreen.main.bounds.width / 2) - 3
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 00, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        
        moreOptionCollectionView.collectionViewLayout = layout
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreOptionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreOptionCell", for: indexPath) as! MoreOptionCollectionViewCell
        
        cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(1).cgColor
        cell.layer.borderWidth = 0.5
        
        cell.moreOptionTextLabel.text = moreOptionList[indexPath.row]
        cell.moreOptionIconImageView.image = UIImage(named: moreOptionIconList[indexPath.row])
        
        return cell
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
