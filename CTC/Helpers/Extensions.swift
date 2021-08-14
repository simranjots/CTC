import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
     
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func makeCardView(){
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize( width: 0, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor(displayP3Red: 41/255, green: 100/255, blue: 188/255, alpha: 1).cgColor
        self.layer.borderWidth = 3
        
    }
    
    func setPopupView() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
    }
    
}
extension UITextField{
    
    
    func setUnderLine(){
        
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        self.layer.cornerRadius = 2
    }
    
    func setLeftPadding(iconName: String){
        
        let heigh = self.frame.height
        let width = self.frame.width * 0.15
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: heigh))
        
        let imageHeight = paddingView.frame.height - paddingView.frame.height * 0.50
        let imageWidth = paddingView.frame.width - paddingView.frame.width * 0.50
        let imageX = paddingView.frame.width * 0.20
        
        
        let y = (paddingView.frame.height/2) - (imageHeight/2)
        
        let imageView = UIImageView(frame: CGRect(x: imageX, y: y, width: imageWidth, height: imageHeight))
        //        imageView.layer.borderWidth = 1
        imageView.image = UIImage(named: iconName)
        paddingView.addSubview(imageView)
        self.leftView = paddingView
        self.leftViewMode = .always
        
    }
    
    
    
    func customePlaceHolder(text : String, color: UIColor){
        
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
}

extension UIButton{
    
    func loginButton(){
        
        self.layer.borderWidth = 0.4
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 7
        self.layer.backgroundColor = UIColor(displayP3Red: 133/255, green:195/255, blue: 218/255, alpha: 1).withAlphaComponent(1).cgColor
        
    }
    
    func setPopUpButton() {
        
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        self.layer.borderWidth = 0.5
        
    }
    
}

extension UIViewController {
    func showToast(message: String, duration: Double) {
            let toastContainer = UIView(frame: CGRect())
            toastContainer.backgroundColor = UIColor.black
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 25;
            toastContainer.clipsToBounds  =  true

            let toastLabel = UILabel(frame: CGRect())
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font.withSize(12.0)
            toastLabel.text = message
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0

            toastContainer.addSubview(toastLabel)
            view.addSubview(toastContainer)

            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastContainer.translatesAutoresizingMaskIntoConstraints = false

            let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
            let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
            let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
            let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
            toastContainer.addConstraints([a1, a2, a3, a4])

            let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 65)
            let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -65)
            let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -75)
            self.view.addConstraints([c1, c2, c3])

        UIView.animate(withDuration: duration, animations: {
            toastContainer.alpha = 1
        }) { (true) in
            
            UIView.animate(withDuration: duration, animations: {
                toastContainer.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: duration, animations: {
                    toastContainer.alpha = 0
                }) { (true) in
                    UIView.animate(withDuration: 1, animations: {
                        DispatchQueue.main.async(execute: {
                            toastContainer.alpha = 0
                            toastLabel.removeFromSuperview()
                            toastContainer.removeFromSuperview()
                            //toastContainer.removeFromSuperview()
                        })
                    })
                }
            }
            
            
        }
        }
    
    
    func show(message : String, duration: Double) {
        let overlayView = UIView()
        let backView = UIView()
        let lbl = UILabel()
        
        let white = UIColor ( red: 1/255, green: 0/255, blue:0/255, alpha: 0.0 )
        
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        overlayView.backgroundColor = white
        overlayView.alpha = 0.0
        overlayView.layer.cornerRadius = 10;
        overlayView.clipsToBounds  =  true
        view.addSubview(backView)
        
        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60  , height: 40)
        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 150)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.0
        overlayView.layer.cornerRadius = 10;
        overlayView.clipsToBounds  =  true
        
        lbl.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 40)
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center;
        lbl.font.withSize(12.0)
        lbl.text = message
        lbl.clipsToBounds  =  true
        lbl.numberOfLines = 0
        lbl.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(lbl)
        
        view.addSubview(overlayView)
        
        
        UIView.animate(withDuration: 1, animations: {
            overlayView.alpha = 1
        }) { (true) in
            
            UIView.animate(withDuration: duration, animations: {
                overlayView.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: duration, animations: {
                    overlayView.alpha = 0
                }) { (true) in
                    UIView.animate(withDuration: 1, animations: {
                        DispatchQueue.main.async(execute: {
                            overlayView.alpha = 0
                            lbl.removeFromSuperview()
                            overlayView.removeFromSuperview()
                            backView.removeFromSuperview()
                        })
                    })
                }
            }
            
            
        }
        
    }
    
    func showAlert(title:String, message: String, buttonTitle: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createDoneToolBar(textField: UITextField){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissKeyboard))
//
        //toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
}
extension Date {
    // Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    // Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func dateFormate() -> Date?{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: self) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        let finalDate = formatter.date(from: myStringafd)
        //        print(myStringafd)
        // Do any additional setup after loading the view.
        return finalDate
        
    }
    func dateFormatemmmdd() -> String?{
        
        let formatter = DateFormatter()
        
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: self) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "MMM d, yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        //        let finalDate = formatter.date(from: myStringafd)
        //        print(myStringafd)
        // Do any additional setup after loading the view.
        return myStringafd
        
    }
    
    
    
    
    func dateFormateToString() -> String?{
        
        let formatter = DateFormatter()
        
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: self) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        //        let finalDate = formatter.date(from: myStringafd)
        //        print(myStringafd)
        // Do any additional setup after loading the view.
        return myStringafd
        
    }
    
    func originalFormate() -> Date {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: self) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        return yourDate!
    }
    
    func getDates(date:Date) -> [Date] {
        
        var dateArray = [Date]()
        var startdate = self // first date
        let endDate = date// last date
        
        // Formatter for printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        
        // While date <= endDate ...
        
        
        while  startdate <= endDate {
            
            let tempDate = fmt.string(from: startdate)
            dateArray.append(fmt.date(from: tempDate)!)
            startdate = Calendar.current.date(byAdding: .day, value: 1, to: startdate)!
        }
        
        if(fmt.string(from: startdate) == fmt.string(from: endDate)){
            
            dateArray.append(startdate)
        }
        
        return dateArray
    }
    
    
    func getDayOfWeek() -> Int? {
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
        
    }
    func getMonth() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let monthString = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        return monthString + yearString
    }
    
    
}

extension String{
    
    func stringToDate() -> Date {
        
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        return fmt.date(from: self)!
        
    }
    
    var isValidEmail: Bool{
        
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [emailRegex])
        
        return emailTest.evaluate(with: self)
        //        return  true
        
    }
    var isValidPassword: Bool{
        
        let passRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passTest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [passRegex])
        
        return passTest.evaluate(with: self)
        
        //        return true
    }
    
}

extension UITableViewCell{
    
    
    func showToast(message : String, duration: Double, view: UIView) {
        let overlayView = UIView()
        let backView = UIView()
        let lbl = UILabel()
        
        let white = UIColor ( red: 1/255, green: 0/255, blue:0/255, alpha: 0.0 )
        
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        backView.center = view.center
        backView.backgroundColor = white
        view.addSubview(backView)
        
        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60  , height: 50)
        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 100)
        overlayView.backgroundColor = UIColor.black
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.alpha = 0
        
        lbl.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 50)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.white
        lbl.center = overlayView.center
        lbl.text = message
        lbl.textAlignment = .center
        lbl.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(lbl)
        
        view.addSubview(overlayView)
        
        
        UIView.animate(withDuration: 1, animations: {
            overlayView.alpha = 1
        }) { (true) in
            
            UIView.animate(withDuration: duration, animations: {
                overlayView.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: duration, animations: {
                    overlayView.alpha = 0
                }) { (true) in
                    UIView.animate(withDuration: 1, animations: {
                        DispatchQueue.main.async(execute: {
                            overlayView.alpha = 0
                            lbl.removeFromSuperview()
                            overlayView.removeFromSuperview()
                            backView.removeFromSuperview()
                        })
                    })
                }
            }
            
            
        }
        
    }
    
    func showAlert(title:String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        
        //        self.present(alert, animated: true, completion: nil)
        
    }
    
}
extension UILabel{
    
    func setPopUpTitle() {
        
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.backgroundColor = UIColor.white
        
    }
    
}

