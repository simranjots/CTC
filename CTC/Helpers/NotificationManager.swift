import Foundation
import UserNotifications
import CoreLocation

class NotificationManager{
    static var instance = NotificationManager()
    
    func requestAuthorization()-> Bool{
        let option: UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: option) { success, error in
            if let error = error {
                print("ERROR: \(error)")
            }else{
                print("SUCCESS")
            }
        }
        return true
    }
    func scheduleNotification(hour: Int,minute:Int,weekday:Int) {
        
      let content = UNMutableNotificationContent()
        content.title = "This is "
        content.subtitle = " my "
        content.sound = .default
        content.badge = 1
        
        //time
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        //calender
        var  dateComponnet = DateComponents()
        dateComponnet.hour = hour
        dateComponnet.minute = minute
        //dateComponnet.weekday = 2 // monday
        let tri = UNCalendarNotificationTrigger(dateMatching: dateComponnet, repeats: true)
        
        //location
        let coordinates = CLLocationCoordinate2D(
            latitude: 40.0,
            longitude: 50.0)
        let region = CLCircularRegion(center: coordinates,
                                      radius: 100,
                                      identifier: UUID().uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        _ = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: tri)
        UNUserNotificationCenter.current().add(request)
       
    }
    func cancelNotification()  {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}
