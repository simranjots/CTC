import UIKit
import CoreData
import UserNotifications
import Firebase
//import GoogleSignIn
import FirebaseAuth
//import FBSDKCoreKit
import FirebaseMessaging
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar =  false
        IQKeyboardManager.shared.shouldResignOnTouchOutside =  true
       
        //MARK: Firebase Configuration
        FirebaseApp.configure()
        
       //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        // [START set_messaging_delegate]
          Messaging.messaging().delegate = self
          // [END set_messaging_delegate]
          // Register for remote notifications. This shows a permission dialog on first run, to
          // show the dialog at a more appropriate time move this registration accordingly.
          // [START register_for_notifications]
          if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: {_, _ in })
          } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
          }

          application.registerForRemoteNotifications()

          // [END register_for_notifications]
        
        //MARK: for path od coredata
//        let urls = FileManager.default.urls(for: .documentDirectory, in:   .userDomainMask)
//        print("Address \(urls)")
        
        //MARK:  to select app launch
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainNavigationController()
        
        
        let currentUser = CurrentUser()
        let userPractice = UserPractices()
        let userPracticeData = UserPracticesData()
        let practiceHistory = PracticedHistory()
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
                            let pracData = userPracticeData.getPracticeDataObj(practiceName: goal.practice!)
                            let pracName = goal.practice
                            let td = (pracData?.tracking_days)!
                            let dss = (Date().dateFormate()!).days(from: (goal.startedday! as Date).dateFormate()!) + 1
                            let flag = false
                            let date = Date().dateFormate()!
                            userPractice.deletePractice(practice: goal)
                            let resultFlag = practiceHistory.addPracticeHistory(practiceName: pracName!, comDelFlag: flag, date: date, dss: dss, td: Int(td), userOb: userObject!)
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
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
        print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
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

  // [START ios_10_message_handling]
  @available(iOS 10, *)
  extension AppDelegate : UNUserNotificationCenterDelegate {

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // [START_EXCLUDE]
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
      // [END_EXCLUDE]
      // Print full message.
      print(userInfo)

      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo

      // [START_EXCLUDE]
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
      // [END_EXCLUDE]
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print full message.
      print(userInfo)

      completionHandler()
    }
  }
  // [END ios_10_message_handling]

  extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
      
      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    
  }

//extension AppDelegate  {
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let handledFB =  ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//        let handledGoogle = GIDSignIn.sharedInstance().handle(url)
//        return handledFB || handledGoogle
//    }
//
//
//
//}
//
