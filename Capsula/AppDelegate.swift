//
//  AppDelegate.swift
//  Capsula
//
//  Created by SherifShokry on 12/23/19.
//  Copyright © 2019 SherifShokry. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import TwitterKit
import MOLH
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import Intercom
import Moya
import CoreLocation




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , MessagingDelegate {
    
    var window: UIWindow?
    static let googleSignInId = "\(Constants.KEYS.googleSignInKey).apps.googleusercontent.com"
    let INTERCOM_APP_ID = "zwlcn8xj"
    let INTERCOM_API_KEY = "ios_sdk-55af3668b7fab69cfbd8603ec8bcf1d4bb8ff1a3"
   // private let provider = MoyaProvider<DeliveryManRegistrationDataSource>()
   // let locationManager = LocationManager()
//    var backgroundTask = UIBackgroundTaskIdentifier(rawValue: 1)
    
   
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
     //   UIApplication.shared.setMinimumBackgroundFetchInterval(60)
        
     //   if application.backgroundRefreshStatus == .available {
//          
//            locationManager.getlocationForUser { (userLocation: CLLocation) -> () in
//             print("LOCLOC : \(userLocation)")
//                
//            }
  
    //    }

        Intercom.setApiKey(INTERCOM_API_KEY, forAppId: INTERCOM_APP_ID)
        GMSServices.provideAPIKey("AIzaSyCx2XM-jUdvo5cOSJWIBwcayQEL4MO9-OQ")
        GMSPlacesClient.provideAPIKey("AIzaSyCx2XM-jUdvo5cOSJWIBwcayQEL4MO9-OQ")
        
        if LocalizationSystem.sharedInstance.getLanguage().contains("ar"){
            UIFont.overrideInitialize()
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            UIFont.overrideInitializeForEN()
           UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        FirebaseApp.configure()
        
        MOLH.shared.activate(false)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //        TWTRTwitter.sharedInstance().start(withConsumerKey: Constants.KEYS.twitterConsumerKey, consumerSecret:  Constants.KEYS.twitterConsumerSecretKey)
        GIDSignIn.sharedInstance().clientID = AppDelegate.googleSignInId
        let isNotificationOff = UserDefaults.standard.bool(forKey: "NotificationOff")
        
        if !isNotificationOff{
            setNotifications(application: application)
        }
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = UIColor.init(red: 55/255, green: 182/255, blue: 255/255, alpha: 1)
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: (sharedApplication.delegate?.window??.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor =  UIColor.init(red: 55/255, green: 182/255, blue: 255/255, alpha: 1)
            sharedApplication.delegate?.window??.addSubview(statusBar)
        }else{
            UINavigationBar.appearance().clipsToBounds = true
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = UIColor.init(red: 55/255, green: 182/255, blue: 255/255, alpha: 1)
        }
        
        Utils.openSplashScreen()
        
        
        #if DEBUG
        Intercom.enableLogging()
        #endif
        
        let isDeliveryMan = UserDefaults.standard.bool(forKey: "isDelivery")
        if isDeliveryMan{
            if Utils.loadDeliveryUser()?.accessToken ?? "" != "" {
                Intercom.registerUser(withEmail: Utils.loadDeliveryUser()?.user?.email ?? "")
                let userAttributes = ICMUserAttributes()
                userAttributes.customAttributes = ["Type" : "Delivery man"]
                Intercom.updateUser(userAttributes)

            }
        }else{
            if Utils.loadUser()?.accessToken ?? "" != "" {
                Intercom.registerUser(withEmail: Utils.loadUser()?.user?.email ?? "")
                let userAttributes = ICMUserAttributes()
                userAttributes.customAttributes = ["Type" : "Client"]
                Intercom.updateUser(userAttributes)
                
            }
            
        }
        
        registerNotificationCategories()
        
        
        return true
    }
    
    
    
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
////        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
////
////
////            application.endBackgroundTask(self.backgroundTask)
////            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
////        })
//
////        let isDeliveryMan = UserDefaults.standard.bool(forKey: "isDelivery")
//        let deliveryUser = Utils.loadDeliveryUser()
//
//
//
//        if ((deliveryUser?.accessToken ?? "") != ""){
//
//
//            locationManager.getlocationForUser { (userLocation: CLLocation) -> () in
//
//
//
//                let locationRequest = LocationRequest()
//                locationRequest.latitude = userLocation.coordinate.latitude
//                locationRequest.longitude = userLocation.coordinate.longitude
//
//                self.geocode(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude) { placemark, error in
//                    guard let placemark = placemark, error == nil else { return }
//
//    locationRequest.addressDesc = (placemark.thoroughfare ?? "") + " " + (placemark.subThoroughfare ?? "")
//
//        self.provider.request(.updateLocation(locationRequest)) { [weak self] result in
//                      //  guard let self = self else { return }
//                        switch result {
//                        case .success(_):
//
//                             completionHandler(.newData)
//                            break
//                        case .failure(_):
//
//                              completionHandler(.newData)
//                            break
//                        }
//                    }
//                }
//            }
//        }
//
//         completionHandler(.newData)
//    }
//
    
//    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
//        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
//    }
//
    
    
    
    
    
    
    
    
    
    
    
    
    private func registerNotificationCategories() {
        let acceptOrderAction = UNNotificationAction(identifier: "ACCEPT", title: Strings.shared.accept, options: UNNotificationActionOptions.foreground)
        let cancelOrderAction = UNNotificationAction(identifier: "CANCEL", title: Strings.shared.cancel, options: UNNotificationActionOptions.foreground)
        
        let contentAddedCategory = UNNotificationCategory(identifier: "order_notification", actions: [acceptOrderAction,cancelOrderAction], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([contentAddedCategory])
    }
    
    
    func setNotifications(application: UIApplication){
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL?)
        
        let facebookDidHandle = ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        
        
        let twitterAuthentication = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        if url.scheme?.localizedCaseInsensitiveCompare("com.BinoyedSA.Capsula.payments") == .orderedSame {
            // Send notification to handle result in the view controller.
            NotificationCenter.default.post(name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
            return true
        }
        
        return googleDidHandle || facebookDidHandle || twitterAuthentication
    }
    
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Intercom.setDeviceToken(deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("FCM TOKEN \n \(fcmToken)")
        let defaults = UserDefaults.standard
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        defaults.set(fcmToken, forKey: "device_token")
        defaults.set(deviceId , forKey: "device_id")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        //        let center = UNUserNotificationCenter.current()
        //         // Request permission to display alerts and play sounds.
        //        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        //
        //            UIApplication.shared.registerForRemoteNotifications()
        //        }
//        AppEvents.activateApp()
//              AppLinkUtility.fetchDeferredAppLink { (url, error) in
//                  if (error != nil) {
//                    return
//                  }
//              }
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handle: Bool = true
        
        let options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject, UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        
        handle = TWTRTwitter.sharedInstance().application(application, open: url, options: options)
        
        
        return handle
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // let userInfo = notification.request.content.userInfo
        
        completionHandler([.alert,.sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        var productItem = Item()
        do {
            let productData =  userInfo["product"] as? String ?? ""
            let productDetailsDic = try JSONSerialization.jsonObject(with:
                productData.data(using: .utf8)!, options: []) as? [String:Any] ?? [String:Any]()
            productItem.imagePath = productDetailsDic["imagePath"] as? String ?? ""
            productItem.price = productDetailsDic["price"] as? Double ?? 0.0
            productItem.isTreatment = productDetailsDic["isTreatment"] as? Bool ?? false
            productItem.itemQuantity = 1
            productItem.mainId = productDetailsDic["mainId"] as? Int ?? 0
            productItem.offerDesc = productDetailsDic["offerDesc"] as? String ?? ""
            productItem.offerType = productDetailsDic["offerType"] as? Int ?? 0
            productItem.priceInOffer = productDetailsDic["priceInOffer"] as? Double ?? 0.0
            productItem.productDesc = productDetailsDic["productDesc"] as? String ?? ""
            productItem.productId = productDetailsDic["productId"] as? Int ?? 0
            productItem.productName = productDetailsDic["productName"] as? String ?? ""
            productItem.storeId = productDetailsDic["storeId"] as? Int ?? 0
            productItem.storeName = productDetailsDic["storeName"] as? String ?? ""
            productItem.vat = productDetailsDic["vat"] as? Int ?? 0
        }catch {
            print(error)
        }
        
        /// Identify the action by matching its identifier.
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            // the user swiped to unlock
            notificationResponse(type : userInfo["type"] as? String ?? "", orderId : userInfo["orderId"]  as? String ?? "", orderStatus: 4 , productDetails: productItem)
        case "ACCEPT":
            // the user tapped our "show more info…" button
            notificationResponse(type : userInfo["type"] as? String ?? "", orderId : userInfo["orderId"]  as? String ?? "", orderStatus: 4 , productDetails: productItem)
        case "CANCEL":
            // the user tapped our "show more info…" button
            notificationResponse(type : userInfo["type"] as? String ?? "", orderId : userInfo["orderId"]  as? String ?? "", orderStatus: 3 , productDetails: productItem)
        default:
            print("DEFAULT :)")
            break
        }
        
        
        
        completionHandler()
    }
    
    func prepareProductDetails (productDetails: String) -> Item{
        
        
        let jsonData = productDetails.data(using: .utf8)!
        let productItem : Item =   try! JSONDecoder().decode(Item.self, from: jsonData)
        
        return productItem
    }
    
    
    func notificationResponse(type : String,orderId : String,orderStatus: Int, productDetails : Item){
        
        switch Int(type) {
        case 6:
            if Utils.loadDeliveryUser() != nil {
                let vc = DeliveryHomeVC.instantiateFromStoryBoard(appStoryBoard: .Home)
                if let currentController = window?.visibleViewController as? DeliveryHomeVC {
                    if orderStatus == 4 {
                        currentController.changeOrderStatus(orderId: Int(orderId) ?? -1, statusId: orderStatus)
                    }else{
                        currentController.rejectOrder(orderId: Int(orderId) ?? -1)
                    }
                    
                }else{
                    UIApplication.shared.windows[0].rootViewController = vc
                    UIApplication.shared.windows[0].makeKeyAndVisible()
                    let orderDataDict:[String: Int] = ["orderId": Int(orderId) ?? 0 , "orderStatus": orderStatus]
                    NotificationCenter.default.post(name: Notification.Name(Constants.CHANGE_ORDER_STATUS), object: nil,userInfo: orderDataDict)
                }
            }
            break
        case 7:
            if Utils.loadUser() != nil {
                let vc = TrackOrderViewController.instantiateFromStoryBoard(appStoryBoard: .Home)
                var dummyOrder = Order()
                dummyOrder.id = Int(orderId)
                vc.order = dummyOrder
                if let currentController = window?.visibleViewController as? TrackOrderViewController {
                    currentController.getOrderTrackingData()
                }else{
                    window?.visibleViewController?.present(vc, animated: true, completion: nil)
                }
            }
            break
        case 5:
            let vc = ItemDetailsRouter.createModule(item: productDetails)
            window?.visibleViewController?.present(vc, animated: true, completion: nil)
            break
        default:
            let vc = NotificationListVC.instantiateFromStoryBoard(appStoryBoard: .Home)
            if let currentController = window?.visibleViewController as? NotificationListVC {
                currentController.getNotificationsData()
            }else{
                window?.visibleViewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}


