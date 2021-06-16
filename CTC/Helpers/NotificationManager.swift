import Foundation
import UserNotifications
import CoreLocation

class NotificationManager{
    static var instance = NotificationManager()
    
    func requestAuthorization(){
        let option: UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: option) { success, error in
            if let error = error {
                print("ERROR: \(error)")
            }else{
                print("SUCCESS")
            }
        }
    }
    func scheduleNotification() {
        
      let content = UNMutableNotificationContent()
        content.title = "This is "
        content.subtitle = " my "
        content.sound = .default
        content.badge = 1
        
        //time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        //calender
        var  dateComponnet = DateComponents()
        dateComponnet.hour = 12
        dateComponnet.minute = 2
        dateComponnet.weekday = 2 // mondday
        _ = UNCalendarNotificationTrigger(dateMatching: dateComponnet, repeats: true)
        //location
        let coordinates = CLLocationCoordinate2D(
            latitude: 40.0,
            longitude: 50.0)
        let region = CLCircularRegion(center: coordinates,
                                      radius: 100,
                                      identifier: UUID().uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let tri = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
       
    }
    func cancelNotification()  {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}
