import UIKit
import CoreData
import UserNotifications
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar =  false
        IQKeyboardManager.shared.shouldResignOnTouchOutside =  true
       
        //MARK: Firebase Configuration
        FirebaseApp.configure()
        
        
        //MARK: for path od coredata
//        let urls = FileManager.default.urls(for: .documentDirectory, in:   .userDomainMask)
//        print("Address \(urls)")
        
        //MARK:  to select app launch
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainNavigationController()
        
        
        let currentUser = CurrentUser()
        let userPractice = UserPractices()
        let dbHelper = DatabaseHelper()
        var userObject: User?
        
        userObject = currentUser.checkLoggedIn()
        if (userObject != nil){
            let days: [String] = ["365 Days"]
            let data = userPractice.getPractices(user: userObject!)
            for goal in data! {
                for day in days {
                    if goal.goals == day{
                        print(day)
                        let startDate = Date().days(from: goal.startedday! as Date  )
                        let Today =  Date().days(from: Date().originalFormate())
                        let diff = startDate - Today
                        if diff > 365 {
                            let pracName = goal.practice
                            let td = goal.practiseddays
                            let dss = (Date().dateFormate()!).days(from: (goal.startedday! as Date).dateFormate()!) + 1
                            let flag = false
                            let date = Date().dateFormate()!
                            userPractice.deletePractice(practice: goal)
                            let resultFlag = dbHelper.addPracticeHistory(practiceName: pracName!, comDelFlag: flag, date: date, dss: dss, td: Int(td))
                            print(resultFlag)
                        }
                        
                       
                    }
                }
                
            }
        }
     
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var initialViewController:UIViewController?
        
        if (userObject != nil){
            NotificationManager.instance.requestAuthorization()
            UIApplication.shared.applicationIconBadgeNumber = 0
            let storyboard = UIStoryboard(name: "TabVC", bundle: nil)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbedBar")
            
        }else{
            NotificationManager.instance.requestAuthorization()
            UIApplication.shared.applicationIconBadgeNumber = 0
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "newLoginOptions")
            
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        //MARK: notification over
        
        return true
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
    
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
   
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
      
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "CTC")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

