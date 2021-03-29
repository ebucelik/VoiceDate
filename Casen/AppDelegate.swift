//
//  AppDelegate.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 09.03.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import AVFoundation
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
//    static let NOTIFICATION_KEY = "https://gcm-http.googleapis.com/gcm/send"
    static var DEVICE_ID = String()
    static let SERVER_KEY = "AAAACucgXz8:APA91bE_vEyKiqR34sruY2f5tetjj_DrwVi42v9tL015tLEOZmwBh-q7oWsNXUrpR0S9XBCrbxMJtgUu70xNAyDeouNvxn1kHKll2Dcwzxbf40lbappxs-o6IDvHVvEajzX5Dzsq8MW8"
    static var EXITAPP = Bool()
    static var LIKESCOUNTER = Int()
    var dateForm = DateFormatter()
    var timeFormatter = DateFormatter()
    static var INSERTTIME = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        registerForPushNotifications()
        if Auth.auth().currentUser?.uid != nil{
            let pushManager = PushNotificationManager(userID: Auth.auth().currentUser?.uid as! String)
            pushManager.registerForPushNotifications()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible() //Damit wir die ganzen Views selber bearbeiten können.
        
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-7410173106752410/2559199677")
        
        if #available(iOS 9.0, *){
            application.isStatusBarHidden = true //HIDE STATUS BAR
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        insertOnlineActivity(online: false)
//        connectToFCM()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        AppDelegate.EXITAPP = true
        insertOnlineActivity(online: false)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        insertOnlineActivity(online: true)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        insertOnlineActivity(online: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        insertOnlineActivity(online: false)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String){
        guard let newToken = InstanceID.instanceID().token() else {return}
        
        AppDelegate.DEVICE_ID = newToken
        connectToFCM()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification.request.content.body
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let newToken = InstanceID.instanceID().token() else {return}
        
        //let newToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        AppDelegate.DEVICE_ID = newToken
        connectToFCM()
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func connectToFCM(){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func insertOnlineActivity(online: Bool){
        var ref: DatabaseReference
        ref = Database.database().reference()
        if Auth.auth().currentUser?.uid != nil{
            ref.child("User").child(Auth.auth().currentUser?.uid as! String).child("Online").setValue(online)
        }
    }
}

