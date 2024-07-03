import FirebaseCore
import FirebaseMessaging
import UserNotifications
import UIKit

public class M2GPush: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    private let appKey: String

    public init(appKey: String) {
        self.appKey = appKey
        super.init()
        print("init M2G push with appKey: \(appKey)")
        configureFirebase()
    }

    private func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        Messaging.messaging().delegate = self
    }

    public func registerForNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Failed to request authorization for notifications: \(error.localizedDescription)")
                return
            }
            if granted {
                print("Notification authorization granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification authorization denied.")
            }
        }
    }

    public func setAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    public func registerToken(userKey: String) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
                return
            }
            guard let fcmToken = token else {
                print("FCM token is nil")
                return
            }

            print("Fetched FCM Token: \(fcmToken)")

            APIService.registerFCMToken(token: fcmToken, appKey: self.appKey, userKey: userKey) { error in
                if let error = error {
                    print("Failed to register token: \(error.localizedDescription)")
                    return
                }

                print("Successfully registered token")
            }
        }
    }
    
    public func subscribeTopic(topic: String) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
                return
            }
            guard let fcmToken = token else {
                print("FCM token is nil")
                return
            }
            
            print("Fetched FCM Token: \(fcmToken)")
            
            Messaging.messaging().subscribe(toTopic: topic) { error in
                if let error = error {
                    print("Error subscribe topic : \(error.localizedDescription)")
                    return
                }
                print("Subscribe topic : \(topic)")
                
                APIService.subscribeTopic(token: fcmToken, appKey: self.appKey, topic: topic) { error in
                    if let error = error {
                        print("Failed to register token: \(error.localizedDescription)")
                        return
                    }

                    print("Successfully registered token")
                }
            }
        }
    }
    
    public func unSubscribeTopic(topic: String) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
                return
            }
            guard let fcmToken = token else {
                print("FCM token is nil")
                return
            }
            
            print("Fetched FCM Token: \(fcmToken)")
            
            Messaging.messaging().subscribe(toTopic: topic) { error in
                if let error = error {
                    print("Error subscribe topic : \(error.localizedDescription)")
                    return
                }
                print("Subscribe topic : \(topic)")
                
                APIService.unSubscribeTopic(token: fcmToken, appKey: self.appKey, topic: topic) { error in
                    if let error = error {
                        print("Failed to register token: \(error.localizedDescription)")
                        return
                    }

                    print("Successfully registered token")
                }
            }
        }
    }

    // Handle received FCM token
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("FCM Token: \(token)")
        } else {
            print("Failed to retrieve FCM token")
        }
    }

    // Show notifications while the app is in the foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
}
