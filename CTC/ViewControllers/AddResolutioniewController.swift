
import UIKit

class AddResolutioniewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var ResolutionTextField: UITextField!
    @IBOutlet weak var ResolutionTableView: UITableView!
    @IBOutlet weak var resolutionIconButton: UIButton!
    
    
    
    
    var list = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     self.ResolutionTableView.keyboardDismissMode = .interactive
        

        
    }
    
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "AddResolutionTableCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            list.remove(at: indexPath.row)
            ResolutionTableView.deleteRows(at: [indexPath], with: .bottom)
            
        }
    }
    
    
    
    
    
    @IBAction func AddResolutionButtonTapped(_ sender: Any) {
        
        list.append(ResolutionTextField.text!)
        ResolutionTableView.reloadData()
        ResolutionTextField.text = ""
        
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
