//
//  AppDelegate.swift
//  MoodPocket
//
//  Created by 曾冰洁 on 2017/12/4.
//  Copyright © 2017年 曾冰洁. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let savedDiaries = Diary.loadDiaries() {
            if savedDiaries.count > 0 {
                diaries += savedDiaries
            } else {
                Diary.loadSampleDiaries()
            }
        } else {
            Diary.loadSampleDiaries()
        }
        // 按时间排序
        diaries.sort(by: { (d1, d2) -> Bool in
            return d1.date > d2.date
        })
        if let savedConfig = Config.loadConfig() {
            config = savedConfig
        } else {
            Config.loadDefaultConfig()
        }
        if let savedLetters = Letter.loadLetters(){
            if savedLetters.count > 0 {
                letters += savedLetters
            } else {
                Letter.loadSampleLetters()
            }
        } else {
            Letter.loadSampleLetters()
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
        if config.NEED_PWD {
            if let currentVisibleViewController = ((window?.rootViewController) as! UITabBarController).selectedViewController{
                if let currentVisibleViewController2 = (currentVisibleViewController as! UINavigationController).visibleViewController{
                    if (currentVisibleViewController2.isKind(of: EnterPasswordUIViewController.self)){
                        if config.PWD_VIEW_MODE=="MODIFY" || config.PWD_VIEW_MODE=="SWITCHOFF" || config.PWD_VIEW_MODE=="NEW" || config.PWD_VIEW_MODE=="NEWAGAIN" {
                            currentVisibleViewController2.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if config.NEED_PWD {
            config.PWD_VIEW_MODE = "ENTER"
            if let currentVisibleViewController = ((window?.rootViewController) as! UITabBarController).selectedViewController{
                if let currentVisibleViewController2 = (currentVisibleViewController as! UINavigationController).visibleViewController{
                    if !(currentVisibleViewController2.isKind(of: EnterPasswordUIViewController.self)){
                        currentVisibleViewController2.performSegue(withIdentifier: "EnterPwd", sender: currentVisibleViewController2)
                    }
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MoodPocket")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

