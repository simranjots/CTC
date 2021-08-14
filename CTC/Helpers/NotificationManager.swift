import Foundation
import UserNotifications
import CoreLocation

class NotificationManager{
    
    static var instance = NotificationManager()
    
    func requestAuthorization(){
        
        let option: UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: option) {
            
            success, error in
            if let error = error {
                print("ERROR: \(error)")
            
            } else {
                print("SUCCESS")
                print(success)
                UserDefaults.standard.set(success, forKey: "Permission")
            }
        }
    }
    
    func scheduleNotification(hour: Int,minute:Int,weekday:Int?,identifier:String,title: String,body:String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
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
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        
       
    }
    
    
}
