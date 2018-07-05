//
//  AppDelegate.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-04-09.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import GooglePlaces
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Set the Google Place API's autocomplete UI control
    GMSPlacesClient.provideAPIKey("AIzaSyANS_Bmalx3Gk-XG2afagd6nDjfB4gabeE")
    let barBrown: UIColor = #colorLiteral(red: 0.6784313725, green: 0.4235294118, blue: 0.2078431373, alpha: 1)
    let lightBrown: UIColor = #colorLiteral(red: 0.9450980392, green: 0.8549019608, blue: 0.7215686275, alpha: 1)
    let darkBrown: UIColor = #colorLiteral(red: 0.4, green: 0.3568627451, blue: 0.3019607843, alpha: 1)
    UINavigationBar.appearance().barTintColor = barBrown
    UINavigationBar.appearance().tintColor = UIColor.white
    let searchBarTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: lightBrown, NSAttributedStringKey.font.rawValue: UIFont(name: "Helvetica Neue", size: 16)]
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
    // Color of the default search text.
    let placeholderAttributes = [NSAttributedStringKey.foregroundColor: lightBrown, NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 15)]
    let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
    
    

    // Tabbar appearance
    UITabBar.appearance().unselectedItemTintColor = UIColor.white
    
    // TableView selected cell's color
    let backgroundColorView = UIView()
    backgroundColorView.backgroundColor = lightBrown
    UITableViewCell.appearance().selectedBackgroundView = backgroundColorView
    UITableView.appearance().separatorColor = UIColor.lightGray
    UITableView.appearance().separatorInset = .zero
    
    // Create an ImageStore
    let imageStore = ImageStore()
    let createController = CreateVC()
    createController.imageStore = imageStore
    
    // Migration config for realm
    let config = Realm.Configuration(
      schemaVersion: 1,
      migrationBlock: { migration, oldSchemaVersion in
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
          
        }
    })
    
    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config
    
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

