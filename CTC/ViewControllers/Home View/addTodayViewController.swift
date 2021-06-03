import UIKit

class addTodayViewController: UIViewController{
    
   // variables
    
    var dbHelper: DatabaseHelper!
    var userObject: User!
    var selectedDate: Date!
    var practicesArray: [Practice]!
    var myIndex: Int!
    var firstDayOfYear : Date! = DateComponents(calendar: .current, year: 2019, month: 1, day: 1).date!
    var currentPractice : Practice!
    var practicesData: [PracticeData]!
    var delegate: ReceiveData?
    var isOn : Bool = false
    
    ////variables
 
    @IBOutlet weak var progressView: CircularProgressView!
    
    
    @IBOutlet weak var percentageLabel: AnimationLabel!
    
    @IBOutlet weak var resolutionTextField: UITextField!
    @IBOutlet weak var resolutionPickerView: UIPickerView!
    
    
    @IBOutlet weak var dayOfYearLabel: UILabel!
    @IBOutlet weak var trackingDayLabel: UILabel!
    @IBOutlet weak var isPracticedSwitch: UISwitch!
    
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var noteBackgroundView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var starButton: UIButton!
    
    
//    @IBOutlet weak var dropDownButton: UIButton!
//    @IBOutlet weak var dropDownTableView: UITableView!
//    @IBOutlet weak var dropDownTableViewHC: NSLayoutConstraint!
//
    var isTableViewVisible = false
    
    var startValue: Double = 0
    var endValue: Double = 70
    var animationDuration: Double = 2.0
    let animationStartDate = Date()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper = DatabaseHelper()
        
        
        self.title = selectedDate.dateFormatemmmdd()!
        
        // getting current yeat
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy"
        // again convert your date to string
        let year = formatter.string(from: yourDate!)
         firstDayOfYear = DateComponents(calendar: .current, year: Int(year), month: 1, day: 1).date!
        
        //// getting current year
        
        
        practicesArray = dbHelper.getPractices(user: userObject)!
        practicesData =  dbHelper.getPracticeDataByDate(date: selectedDate.dateFormate()!)
        print(practicesData)
        
        
       
        
        noteTextView.delegate = self
        
        let date5 = DateComponents(calendar: .current, year: 2019, month: 2, day: 10).date!
        let now = Date()
        let timeOffset3 = now.days(from: date5)
//        print(timeOffset3)
        
        
//        print(myIndex)
         currentPractice = practicesArray[myIndex]
//        resolutionTextField.text = "\(String(describing: (practicesArray[myIndex].practice)!))"
//        trackingDayLabel.text = "\(practicesArray[myIndex].practiseddays)/\(Date().days(from: practicesArray[myIndex].startedday! as Date))"
        
        
        
        resolutionTextField.setUnderLineWithColor(color: UIColor.lightGray, alpha: 0.5)
        
        createPickerView()
        createToolBarForNoteTextArea()
        createToolBar()
        
        saveButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = saveButton.frame.height * 0.3
        saveButton.backgroundColor = Theme.secondaryColor
        
        
        noteBackgroundView.layer.borderWidth = 0.5
        noteBackgroundView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        noteBackgroundView.layer.cornerRadius = 10
        
        
        noteTextView.text = "Write Your Notes Here. . . "
        noteTextView.textColor = UIColor.lightGray
        
        
//        
//        let barButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveButtonTapped))
//        
//        navigationItem.rightBarButtonItem = barButton
    
        
//        customizetextField(textField: resolutionTextField)
        
        
        // Do any additional setup after loading the view.
//
//        let cp = CircularProgressView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
//        cp.progressColor = UIColor.yellow
//        cp.trackColor = UIColor.red
//        cp.center = self.view.center
//        cp.tag = 304
//        self.view.addSubview(cp)
//        self.perform(#selector(animateProgress), with: nil, afterDelay: 2.0)
        
        
        // listener for keyboard
        
        
        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.setData()
    }
    
    func setData() {
        print((practicesArray[myIndex].startedday)! as Date)
        let startedDate = ((practicesArray[myIndex].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        
        print(startedDate)
        
        resolutionTextField.text = practicesArray[myIndex].practice
        dayOfYearLabel.text = "\(days)"
        let practicedDays = Int(practicesArray[myIndex].practiseddays)
        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
        
        setPercentageAnimation(percentageValue: percentage)
        trackingDayLabel.text = "\(practicesArray[myIndex].practiseddays)"
        
        if(practicesData != nil){
            
            for data in practicesData{
                
                if data.practiceDataToPractice == practicesArray[myIndex]{
                    let temp = data.note
                    noteTextView.text = temp == "" || temp == nil ? "Write Your Notes Here. . . " : temp
                    self.activeButton(flag: data.practised)
//                    isPracticedSwitch.isOn = data.practised
                    
                }
                
            }
            
        }
        
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    //MARK: Save button tapped from bar
    @objc func saveButtonTapped() {
        
        let ispracticed = isPracticedSwitch.isOn
        var noteData = noteTextView.text
        if noteData == "Write Your Notes Here. . . "{
            noteData = ""
        }
        
        
        let savingResult = dbHelper.addPracticeData(note: noteData!, practised: ispracticed, practice: currentPractice,date: selectedDate)
        
        if(savingResult == 0){
            
            showToast(message: "Data Saved. . .", duration: 3)
            delegate?.passUserObject(user: userObject)
//            dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController(animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
//            let vc = storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
//            self.navigationController?.popToViewController(vc, animated: true)
            
//            performSegue(withIdentifier: "addDataToHomeSegue", sender: self)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if(savingResult == 1){
            showAlert(title: "Error", message: "Datasaving Error Please try again. . .", buttonTitle: "Try Again")
        }
        
    }
    // MARK: save button tapped from bar

    func setPercentageAnimation(percentageValue: Int){
        
        let percentageFloat : Float = Float(percentageValue)
        let percentageInPoint : Float = percentageFloat / 100
        
        progressView.trackColor = UIColor.lightGray
        progressView.progressColor = UIColor(displayP3Red: 64/255, green: 224/255, blue: 208/255, alpha: 1)
        progressView.setProgressWithAnimation(duration: 2.0, value: percentageInPoint)
        
        percentageLabel.startAnimation(fromValue: 0, to: percentageFloat, withDuration: 2, andAnimatonType: .Linear, andCounterType: .Int)
        
    }
    
    func createPickerView(){
        
        let resolutionPicker = UIPickerView()
        resolutionPicker.delegate = self
        
        resolutionPicker.backgroundColor = .white
        print(myIndex)

        resolutionTextField.inputView = resolutionPicker
        
    }
    
    func createToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissPickerView))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        resolutionTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissPickerView() {
        
//        trackingDayLabel.text = "\(practicesArray[myIndex].practiseddays)"
//        setPercentageAnimation(percentageValue: Int(practicesArray[myIndex].percentage))
//        currentPractice = practicesArray[myIndex]
        
        self.setData()
//        progressViewSet(valuePercentage: resolutionPercentage[myIndex])
        
        
        view.endEditing(true)
    }
    
    func createToolBarForNoteTextArea(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        noteTextView.inputAccessoryView = toolBar
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! HomeViewController
        
        destination.userObject = userObject
        
    }
   
    
//    @objc func dismissKeyboard() {
//
//        view.endEditing(true)
//    }
//

//    @objc func handleUpdate(){
//
//        let now = Date()
//        let elapsedTime = now.timeIntervalSince(animationStartDate)
//
//        if(elapsedTime > animationDuration){
//
////            self.percentageLabel.text = "\(Int(endValue))%"
//        }
//        else {
//
//            let percentage = elapsedTime / animationDuration
//            let value = startValue + percentage * (endValue - startValue)
////            self.percentageLabel.text = "\(Int(value))%"
//
//        }
//
//    }
//    @objc func animateProgress(){
//        
//        let cP = self.view.viewWithTag(304) as! CircularProgressView
//        cP.setProgressWithAnimation(duration: 1.0, value: 1)
//        
//    }
    
//    func progressViewSet(valuePercentage: Int){
//        
//        self.endValue = Double(valuePercentage)
//        self.startValue = 0
//        // Do any additional setup after loading the view.
//        let timeStanmp = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy"
//        let date = formatter.string(from: timeStanmp)
//        self.title = "\(date)"
//        
//        //        customeButton(button: dropDownButton)
//        
////        progressView.trackColor = UIColor.lightGray
////        progressView.progressColor = UIColor.red
////        let percentageValue = Float(valuePercentage)/100
////        progressView.setProgressWithAnimation(duration: 2.0, value: percentageValue)
////
////
////        let displaylink = CADisplayLink(target: self, selector: #selector(handleUpdate))
////        displaylink.add(to: .main, forMode: .default)
////
//    }
//    
    
    
    
    // custome Button
    
    func customeButton(button : UIButton){
        
        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "DropDown"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 100, bottom: 6, right: 14)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -36, bottom: 0, right: 34)
        
   
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func customeSaveButton(button: UIButton){
        
        
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor.white.cgColor
        button.titleLabel?.textColor = UIColor.white
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        button.layer.shadowOpacity = 1.0
        
        
        
    }
    
    func customizeNoteTitle(label : UILabel){
        
        label.layer.cornerRadius = 10
        label.layer.backgroundColor = UIColor.white.cgColor
//        label.titleLabel?.textColor = UIColor.black
        label.layer.shadowColor = UIColor.darkGray.cgColor
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        label.layer.shadowOpacity = 1.0
        
    }
    
    func customizetextField(textField : UITextField){
        
        textField.layer.cornerRadius = 10
        textField.layer.backgroundColor = UIColor.white.cgColor
        //        label.titleLabel?.textColor = UIColor.black
        textField.layer.shadowColor = UIColor.darkGray.cgColor
        textField.layer.shadowRadius = 4
        textField.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        textField.layer.shadowOpacity = 1.0
        
    }
    
    
    @objc func keyboardWillChange(notification: Notification){
        
        print("Keyboard Will Show : \(notification.name.rawValue)")
        
//        guard let keyboradRect = (notification.userInfo[UIResponder.keyboardFrameEndUserInfoKey]) as? NSValue)?.CGRect else {
//
//            return
//        }
        
        if(!resolutionTextField.isEditing){
        
        let keyboardRectangle:CGRect?
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
             keyboardRectangle = keyboardFrame.cgRectValue
            
            if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification){
                
                self.view.frame.origin.y = (-keyboardRectangle!.height+50)
                
            }
            else{
                
                self.view.frame.origin.y = 0
                
            }
            
        }
        
//
//        if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification){
//
//            self.view.frame.origin.y = (-keyboardRectangle!.height+50)
//
//        }
//        else{
//
//            self.view.frame.origin.y = 0
//
//        }
        
        }
        
    }
    
    @IBAction func starButtonTapped(_ sender: Any) {
        
        self.activeButton(flag: !isOn)
        
    }
    
    func activeButton(flag: Bool){
        
        isOn = flag
        if(isOn){
            starButton.setImage(UIImage(named: "Star-Selected"), for: .normal)
            
        }else{
            
            starButton.setImage(UIImage(named: "Star"), for: .normal)
            
        }
    }
   
    @IBAction func saveButtonTappde(_ sender: Any) {
        
        let ispracticed = isOn
        var noteData = noteTextView.text
        if noteData == "Write Your Notes Here. . . "{
            noteData = ""
        }
        
        
        let savingResult = dbHelper.addPracticeData(note: noteData!, practised: ispracticed, practice: currentPractice,date: selectedDate)
        
        if(savingResult == 0){
            
            showToast(message: "Data Saved. . .", duration: 3)
            delegate?.passUserObject(user: userObject)
            //            dismiss(animated: true, completion: nil)
            //            self.navigationController?.popViewController(animated: true)
            //            self.navigationController?.popToRootViewController(animated: true)
            //            let vc = storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            //            self.navigationController?.popToViewController(vc, animated: true)
            
            //            performSegue(withIdentifier: "addDataToHomeSegue", sender: self)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else if(savingResult == 1){
            showAlert(title: "Error", message: "Datasaving Error Please try again. . .", buttonTitle: "Try Again")
        }
        
    }
    
    
}

extension addTodayViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    // Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return practicesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return practicesArray[row].practice
    }
    
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//
//        var myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
//        var myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//
//        var rowString = String()
//        switch row {
//        case 0:
//            rowString = "Home"
//            myImageView.image = UIImage(named:"Home")
//        case 1:
//            rowString = "Profile"
//            myImageView.image = UIImage(named:"Profile")
//
//        default:
//            rowString = "Error: too many rows"
//            myImageView.image = nil
//        }
//        let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60 ))
////        myLabel.font = UIFont(name:some font, size: 18)
//        myLabel.text = rowString
//
//        myView.addSubview(myLabel)
//        myView.addSubview(myImageView)
//
//        return myView
//
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        myIndex = row
        resolutionTextField.text = "\(String(describing: practicesArray[row].practice!))"
        
        
        
//        trackingDayLabel.text = "\(trackingDay[row])"
//        progressViewSet(valuePercentage: resolutionPercentage[row])
//        resolutionTextField.text = "\(Resolutions[row])"
    }

    
    // to Edit the font style of picker view
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        var label = UILabel()
//
//        let view = view as? UILabel
//
//
//        if ((view) != nil){
//
//            label = view!
//
//        }
//        else{
//
//            label = UILabel()
//
//        }
//
////        label.textColor = UIColor.black
//
//        return label
//    }
    
    
    // Picker View
    
}
extension UITextField{
    
    
    func setUnderLineWithColor(color: UIColor, alpha : Float){
        
        self.layer.shadowOpacity = alpha
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = color.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 2
        
    }
    
}

extension addTodayViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            if textView.text == "Write Your Notes Here. . . "{
                textView.text = nil
                
            }
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Your Notes Here. . . "
            textView.textColor = UIColor.lightGray
        }
    }
    
}

protocol ReceiveData {
    func passUserObject(user: User)
}
