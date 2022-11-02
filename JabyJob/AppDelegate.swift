//
//  AppDelegate.swift
//  JabyJob
//
//  Created by DMG swift on 30/12/21.
//
var payment = false
import UIKit
import IQKeyboardManagerSwift
import TTGSnackbar
import GoogleSignIn
//import FirebaseCore
import GoogleSignIn
import AVKit
import SocketIO
//import FirebaseCore
//var isTapOnSideMenu = Bool()
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseMessaging
import UserNotifications
@main

///GoogleCientId//114581213246-00giou2257l5ci5322mrht7r5sa77l2a.apps.googleusercontent.com
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    var replacingShareId = String()
    var replacingUserId = String()
    var replincgVideoId = String()
    
    let signInConfig = GIDConfiguration.init(clientID: "114581213246-00giou2257l5ci5322mrht7r5sa77l2a.apps.googleusercontent.com")
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SokectIoManager.sharedInstance.establishConnection()
    }
   
    func applicationDidEnterBackground(application: UIApplication) {
        SokectIoManager.sharedInstance.closeConnection()
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 2.0)
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let data = userDataShow(userdata: "userData")
        IQKeyboardManager.shared.enable = true
        SokectIoManager.sharedInstance.establishConnection()
        if data.count > 0  {
            
//            ApiClass().isUserLogout = true
            setRootToLogin(controllerVC: AfterLoingTabBarController(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController") 
         
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 10)!], for: UIControl.State.normal)
        }else {
            setRootToLogin(controllerVC: TabBarController(), storyBoard: "TabBar", identifire: "TabBarController")
           
//            IQKeyboardManager.shared.enable = true
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 10)!], for: UIControl.State.normal)
        }
        
       
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                print(user)
              // Show the app's signed-out state.
            } else {
                print(error)
              // Show the app's signed-in state.
            }
          }
       
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
//                application.applicationIconBadgeNumber = self.count
                Messaging.messaging().delegate = self
        return true
    }
    
    //MARK: - UIApplicationDelegate Methods
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        print(userInfo)

        switch application.applicationState {
        case .active:
            let content = UNMutableNotificationContent()
            if let title = userInfo["title"]
            {
                content.title = title as! String
            }
            if let title = userInfo["text"]
            {
                content.body = title as! String
            }
            content.userInfo = userInfo
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier:"rig", content: content, trigger: trigger)

            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request) { (error) in
                if let getError = error {
                    print(getError.localizedDescription)
                }
            }
        case .inactive:
            break
        case .background:
            break
        }
    }
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
         
            print(userInfo)
            completionHandler([.alert, .sound,.badge])
            
        }
        
        // Handle notification messages after display notification is tapped by the user.
        
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            
            print(userInfo)
            completionHandler()
            SokectIoManager.sharedInstance.establishConnection()
            switch UIApplication.shared.applicationState {
            case .active:
                guard
                    let userName = userInfo[AnyHashable("gcm.notification.userName")] as? String,
                    let reciverId = userInfo[AnyHashable("gcm.notification.userId")] as? String,
                    let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
                    let alert = aps["alert"] as? NSDictionary,
                    let body = alert["body"] as? String,
                    let title = alert["title"] as? String
                    else {
                        // handle any error here
                        return
                    }

                print("Title: \(title) \nBody:\(body)")
                
                reciverIdPushNotifion = reciverId
                reciverNamePushNotifion = userName
                isfromNotification = true
                    setRootToLogin(controllerVC: AfterLoingTabBarController(), storyBoard: "ChatVC", identifire: "ChatVC")
                break
            case .inactive:
                print("hsadfhjkasdf")
                guard
                    let userName = userInfo[AnyHashable("gcm.notification.userName")] as? String,
                    let reciverId = userInfo[AnyHashable("gcm.notification.userId")] as? String,
                    let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
                    let alert = aps["alert"] as? NSDictionary,
                    let body = alert["body"] as? String,
                    let title = alert["title"] as? String
                    else {
                        // handle any error here
                        return
                    }

                print("Title: \(title) \nBody:\(body)")
                
                reciverIdPushNotifion = reciverId
                reciverNamePushNotifion = userName
                isfromNotification = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.setRootToLogin(controllerVC: AfterLoingTabBarController(), storyBoard: "ChatVC", identifire: "ChatVC")
                    
                }
                   
                //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
                break
            case .background:
                //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
                break
            default:
                break
            }
           
        }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
        UserDefaults.standard.set(fcmToken ?? "", forKey: "FCMToken")
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
   

    
    
    //MARK: Universal Links
//    public func application(_ application: UIApplication,
//                            continue userActivity: NSUserActivity,
//                            restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        if let url = userActivity.webpageURL {
//            var view = url.lastPathComponent
//            var parameters: [String: String] = [:]
//            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
//                parameters[$0.name] = $0.value
//            }
//
//            redirect(to: view, with: parameters)
//        }
//        return true
//    }
    
    //MARK: Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
     
        ///Check  webpage
        if let webpageUrl = userActivity.webpageURL {
            print("Incoming URL is\(webpageUrl)")
            
            /// if dynamic url does exits
            ///
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(webpageUrl) { dynamicLink, error in
                guard error == nil else {
                    print("Found an error! \(error?.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handelIncomingDynamicLink(dynamicLink)
                }
                
            }
            
            if linkHandled {
                return true
            }else {
                /// Do other thing here
                  return false
            }
            
        }
        
        return false
    }
    
    func handelIncomingDynamicLink(_ dynamicLink: DynamicLink){
        guard let url = dynamicLink.url else {
            print("That's weird. My dynamic link")
            return
        }
      
        let stringUrl = url.absoluteString
        let nesString = stringUrl.replacingOccurrences(of: "%3D", with: "=")
        
        if stringUrl.contains("%3D") {
            ///'IOS DeepLInk"
            let convertString = stringUrl.replacingOccurrences(of: "%3D", with: "=")
            let newURL = URL(string: convertString)!
           

            let components = URLComponents(string: convertString)!
            let params = newURL.query
            let splitParams = params!.components(separatedBy: "%26")
           
            splitParams.compactMap { list in
               print(list)
            }
            print(splitParams[2])
            let videoId = splitParams[2]
            replacingShareId =  videoId.replacingOccurrences(of:"is_shared=", with:"")
            
            let shareId = splitParams[3]
            replacingUserId = shareId.replacingOccurrences(of:"shared_UserID=", with:"")
            
            let userId = splitParams[1]
            replincgVideoId = userId.replacingOccurrences(of:"video_Id=", with:"")
            
            print(replincgVideoId,replacingShareId,replacingUserId)
        }else {
            ///'Android DeepLInk"
            let convertString = stringUrl.replacingOccurrences(of: "%26", with: "=")
            let newURL = URL(string: convertString)!
           

            let components = URLComponents(string: convertString)!
            let params = newURL.query
            let splitParams = params!.components(separatedBy: "&")
           
            splitParams.compactMap { list in
               print(list)
            }
            print(splitParams[1])
            let videoId = splitParams[1]
             replincgVideoId =  videoId.replacingOccurrences(of:"video_Id=", with:"")
            
            let shareId = splitParams[2]
             replacingShareId = shareId.replacingOccurrences(of:"is_shared=", with:"")
            
            let userId = splitParams[3]
             replacingUserId = userId.replacingOccurrences(of:"shared_UserID=", with:"")
            
            print(replincgVideoId,replacingShareId,replacingUserId)
        }
        
        
       
        
        
         isFromDeepLinking = true
         isshare = Int(replacingShareId) ?? 0
         shareduserId = Int(replacingUserId) ?? 0
         shared_videoID = Int(replincgVideoId) ?? 0

        
        NotificationCenter.default.post(name: Notification.Name("deepLinking"), object: nil, userInfo: nil)
        
        print("Your incoming link parameter is\(url.absoluteURL)")
    }
    
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool
        print("i have recived daynamic link\(url.absoluteURL)")
      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url){
            self.handelIncomingDynamicLink(dynamicLink)
            return true
        }
        
        
      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
//        isTapOnSideMenu = true
//        let objToBeSent = false
//        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        NotificationCenter.default.post(name: Notification.Name("stopeP"), object: true)
        print("leave controllerb Remove")
    }
    func applicationWillTerminate(_ application: UIApplication) {
        let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        var dict = [String: Any]()
        dict = ["sender": userid]
        SokectIoManager.sharedInstance.leaveChatRoom(dict: dict)
        SokectIoManager.sharedInstance.removeAllHandlers()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("stop"), object: false)
    }
    

    // MARK: Root controller
    func setRootToLogin(controllerVC: UIViewController, storyBoard: String, identifire: String) {
        let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifire)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController.init(rootViewController: controller)
//        navigationController.navigationBar.barStyle = .blackTranslucent
       
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
    }
     
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}
extension String {
    var URLEncoded:String {

        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharsSet: CharacterSet = CharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharsSet)!
        return encodedString
    }
}
