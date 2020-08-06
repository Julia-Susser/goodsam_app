//
//  AppDelegate.swift
//  FirebaseStarterApp
//
//  Created by Florian Marcu on 2/21/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit
import Firebase
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "goodsam")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {

                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    


    var item :[Any] = []
    var dict = NSMutableDictionary()
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let context = self.persistentContainer.viewContext
        var locations  = [NSManagedObject]() // Where Locations = your NSManaged Class
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        locations = try! context.fetch(fetchRequest) as! [NSManagedObject]
        for location in locations
        {
            item.append(location)
            
        }
       
        
       
         /*let managedObject = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

               // Helpers
               var result = [NSManagedObject]()

               do {
                   // Execute Fetch Request
                   let records = try managedObject.fetch(fetchRequest)

                   if let records = records as? [NSManagedObject] {
                       result = records
                   }
                print(result)

               } catch {
                   print("Unable to fetch managed objects for entity User.")
               }*/
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        if item.count == 1{
            let storyboard = UIStoryboard(name: "main", bundle: nil)

            let myVC = storyboard.instantiateViewController(withIdentifier: "mainViewController") as! mainViewController
            
            
            
            window?.rootViewController = UINavigationController(rootViewController: myVC)
            window?.makeKeyAndVisible()
            
        }else{
            window?.rootViewController = UINavigationController(rootViewController: ATCClassicLandingScreenViewController(nibName: "ATCClassicLandingScreenViewController", bundle: nil))
            window?.makeKeyAndVisible()
            
        }
        
        return true
        // Window setup
       
        
    }
}

