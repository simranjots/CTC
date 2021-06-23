import Foundation
import UserNotifications
import CoreLocation

class NotificationManager{
    
    static var instance = NotificationManager()
    
    var value = true
    
    func requestAuthorization()-> Bool {
        
        let option: UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: option) {
            
            success, error in
            if let error = error {
                print("ERROR: \(error)")
                self.value = false
            } else {
                print("SUCCESS")
                self.value = true
            }
        }
        return value
    }
    
    func scheduleNotification(hour: Int,minute:Int,weekday:Int?,identifier:String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Practice "
        content.body = "Stay on track to meet your goals by learning a litle every day.Let's get started!"
        content.sound = .default
        
        
        var tri : UNCalendarNotificationTrigger
            //calender
            var  dateComponnet = DateComponents()
            dateComponnet.hour = hour
            dateComponnet.minute = minute
            dateComponnet.weekday = weekday
            tri = UNCalendarNotificationTrigger(dateMatching: dateComponnet, repeats: true)
    
        
        
        //        //location
        //        let coordinates = CLLocationCoordinate2D(
        //            latitude: 40.0,
        //            longitude: 50.0)
        //        let region = CLCircularRegion(center: coordinates,
        //                                      radius: 100,
        //                                      identifier: UUID().uuidString)
        //        region.notifyOnEntry = true
        //        region.notifyOnExit = false
        //        _ = UNLocationNotificationTrigger(region: region, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: tri)
        UNUserNotificationCenter.current().add(request)
        
    }
    func cancelNotification(identifier: String)  {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == identifier {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
       
    }
    
    
}
