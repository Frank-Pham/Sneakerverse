//
//  AppDelegate.swift
//  SneakerApp
//
//  Created by Dung  on 19.11.19.
//  Copyright © 2019 Dung. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    static var coreDataContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
//
//    static var viewContext: NSManagedObjectContext {
//        return coreDataContainer.viewContext
//    }
//    let context = AppDelegate.viewContext
    
     func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SneakerObj", in: context)
        let sneaker = NSManagedObject(entity: entity!, insertInto: context)
        sneaker.setValue("Travis Scott AF1", forKey: "name")
        sneaker.setValue("Nike", forKey: "brand")
        sneaker.setValue("12.12.2020", forKey: "date")
        do {
           try context.save()
            print("safe")
          } catch {
           print("Failed saving")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SneakerObj")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
               print(data.value(forKey: "name") as! String)
          }
            
        } catch {
            
            print("Failed")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SneakerApp")
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
    let nserror = error as NSError
    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    }
    }
    
    func saveState(state : String){
        /*
        let newEntry = SneakerObj(context: persistentContainer.viewContext)
        newEntry.name = state
        newEntry.img = "Scott"
        newEntry.date = "12.12.12"
           saveContext()
 */
    }

}

