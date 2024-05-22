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

    public func registerToken(appKey: String, userKey: String) {
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

            let url = URL(string: "https://dev-api.message.to-go.io/message/push/token")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = [
                "token": fcmToken,
                "appKey": appKey,
                "phoneNumber": userKey
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to register token: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Failed to register token with response: \(String(describing: response))")
                    return
                }

                print("Successfully registered token")
            }

            task.resume()
        }
    }
    
    public func subscribeTopic(topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            print("Subscribe topic : \(topic)")
        }
    }
    
    public func unSubscribeTopic(topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            print("Un subscribe topic : \(topic)")
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
