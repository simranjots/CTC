import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    let no = [1,2,3,4]
    
    @IBOutlet weak var historyTableView: HistoryTableView!
    
    var dbHelper: DatabaseHelper!
    var deletedHistory: [PracticeHistory] = []
    var completedHistory: [PracticeHistory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Practice History"
        dbHelper = DatabaseHelper()
        
//        let resultFlag = dbHelper.addPracticeHistory(practiceName: "Prac - 2", comDelFlag: true, date: Date().dateFormate()!, dss: 4, td: 3)
        
        let history = dbHelper.getPracticeHistory()
        
        print(history)
        
        if(history?.count != 0){
            
            for data in history!{
                
                if(data.com_del_flag == true){
                    
                    completedHistory.append(data)
                    
                }else if (data.com_del_flag == false){
                    
                    deletedHistory.append(data)
                    
                }
                
            }
//            print("complete: - - - - : \(completedHistory)")
//            print("Delete: - - - - : \(deletedHistory)")
            
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshTableView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return completedHistory.count != 0 && deletedHistory.count != 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderCell") as! HistoryHeaderCellTableViewCell
        
        if(section == 0){
            
            if(completedHistory.count != 0){
                cell.HeaderTextLabel.text = "Completed Practices"
            }else if (deletedHistory.count != 0){
                cell.HeaderTextLabel.text = "Deleted Practices"
            }else{
                cell.HeaderTextLabel.text = "No History Found"
            }
            
        }else if(section == 1) {
            cell.HeaderTextLabel.text = deletedHistory.count == 0 ? "" : "Deleted Practices"
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            
            if(completedHistory.count != 0 || deletedHistory.count != 0){
                return  1
            }else{
                
                return 0
                
            }
            
        }else {
            
            if deletedHistory.count != 0{
                
                return 1
                
            }else{
                return 0
            }
            
            }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryRecordTableViewCell

        if(indexPath.section == 0){
            
            let bufferArray = completedHistory.count != 0 ? completedHistory : deletedHistory.count != 0 ? deletedHistory : nil
            
            cell.historyData = bufferArray
            cell.noOfPages = bufferArray?.count
            cell.CardPageControl.numberOfPages = (bufferArray?.count)!
            
        } else if(indexPath.section == 1){
            
            cell.historyData = deletedHistory
            cell.noOfPages = deletedHistory.count
            cell.CardPageControl.numberOfPages = deletedHistory.count
            
        }
        cell.HistoryCollectionView.reloadData()
        cell.HistoryCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        cell.CardPageControl.currentPage = 0
        return cell
    }

    
    func refreshTableView() {
        
        completedHistory = []
        deletedHistory = []
        
        let history = dbHelper.getPracticeHistory()
        
        print(history)
        
        if(history?.count != 0){
            
            for data in history!{
                
                if(data.com_del_flag == true){
                    
                    completedHistory.append(data)
                    
                }else if (data.com_del_flag == false){
                    
                    deletedHistory.append(data)
                    
                }
                
            }
            //            print("complete: - - - - : \(completedHistory)")
            //            print("Delete: - - - - : \(deletedHistory)")
            
        }
        
        self.historyTableView.reloadData()
        
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
