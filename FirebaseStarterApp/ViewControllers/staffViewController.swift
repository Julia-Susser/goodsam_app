//
//  staffViewController.swift
//  FirebaseStarterApp
//
//  Created by Julia Susser on 8/3/20.
//  Copyright © 2020 Instamobile. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
class staffViewController: UIViewController {
    var window: UIWindow?
       var item :[Any] = []
       var dict = NSMutableDictionary()
       let appdelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var staffButton: UIButton!
    
    private let tintColor: UIColor = .orange
    private let backgroundColor: UIColor = .white
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = appdelegate.persistentContainer.viewContext
             var locations  = [NSManagedObject]() // Where Locations = your NSManaged Class
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
             fetchRequest.returnsObjectsAsFaults = false
             locations = try! context.fetch(fetchRequest) as! [NSManagedObject]
             for location in locations
             {
                 item.append(location)
                 
             }
             print("here")
             print(item[0])
             
             let dic = item[0]  as! NSManagedObject
             
             let email = dic.value(forKey: "email" ) as? String ?? "default"
             
             let db = Firestore.firestore()
             db.collection("users").whereField("email", isEqualTo: email)
                 .getDocuments() { (querySnapshot, err) in
                     if let err = err {
                         print("Error getting documents: \(err)")
                     } else {
                         for document in querySnapshot!.documents {
                             //print("\(document.documentID) => \(document.data())")
                           print("Start")
                           for (key, value) in document.data(){
                             print("\(key) : \(value)")
                           }
                           print(document.data()["name"] ?? "default")
                           let name = document.data()["name"] ?? "default"
                             self.welcome.text = "Welcome \(name)"
                         }
                     }
             }
             
             
            
             
             
             
            welcome.font = welcome.font.withSize(30)
             
             staffButton.setTitle("Form", for: .normal)
            
             
             
        staffButton.addTarget(self, action: #selector(didTapStaffButton), for: .touchUpInside)
             
          staffButton.configure(color: backgroundColor,
                                       font: buttonFont,
                                       cornerRadius: 40/2,
                                       backgroundColor: UIColor(hexString: "#E13939"))
    
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

      
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

      }

    @objc func didTapStaffButton() {
        
                    
                    let storyboard = UIStoryboard(name: "main", bundle: nil)

                    let myVC = storyboard.instantiateViewController(withIdentifier: "staffFormViewController") as! staffFormViewController
                    self.navigationController?.pushViewController(myVC, animated: true)

    }
               
}
     
