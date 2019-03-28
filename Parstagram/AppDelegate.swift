//
//  AppDelegate.swift
//  Parstagram
//
//  Created by stargaze on 3/21/19.
//  Copyright © 2019 blinkous. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Connect the client side application with the parse server
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Parstagram"
                configuration.server = "https://intense-earth-85223.herokuapp.com/parse"
            })
        )
        
        // Check to see if the parse user is logged in
        if PFUser.current() != nil {
            // If the user is already logged in, switch to the feed view controller
            // Main is just the storyboard name, each storyboard is for different regions of the app
            let main = UIStoryboard(name: "Main", bundle: nil)
            
            // Create an instance of the feed view controller
            let feedNavigationController = main.instantiateViewController(withIdentifier: "FeedNavigationController")
            
            // there is one window per application, this is like the only use case for it. Use it so that if the user is logged in, the app opens directly to the feed view
            window?.rootViewController = feedNavigationController
        }
        return true
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

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

