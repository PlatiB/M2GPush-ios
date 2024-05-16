import FirebaseCore
import FirebaseMessaging
import UserNotifications
import UIKit

public class M2GPush: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    public private(set) var text = "Hello, World!"

    public override init() {
        super.init()
        print("init M2G push")
        configureFirebase()
    }

    private func configureFirebase() {
        FirebaseApp.configure()
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
            } else {
                print("Notification authorization denied.")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

    public func setAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    public func registerToken() {
        print("register token to m2g")
    }

    // Handle received FCM token
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("FCM Token: \(token)")
            // Send the FCM token to your server if needed
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
