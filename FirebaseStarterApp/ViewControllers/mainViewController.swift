//
//  mainViewController.swift
//  FirebaseStarterApp
//
//  Created by Julia Susser on 8/2/20.
//  Copyright © 2020 Instamobile. All rights reserved.
//

import UIKit

import SwiftUI
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
class mainViewController: UIViewController {
let db = Firestore.firestore()
 var ref: DocumentReference!
  var window: UIWindow?
    var item :[Any] = []
    var dict = NSMutableDictionary()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
   
    
 
    @IBOutlet var info: UIButton!
    
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var volenteer: UIButton!
    
    @IBOutlet var client: UIButton!
    
    @IBOutlet var staff: UIButton!
    
    @IBOutlet var welcome: UILabel!
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
        let color = UIColor(hexString: "#282E4F")
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        info.setTitle("Information", for: .normal)
        volenteer.setTitle("Volenteer", for: .normal)
        client.setTitle("Community", for: .normal)
        staff.setTitle("Staff", for: .normal)
       
        
       
        
        
        
     info.configure(color: backgroundColor,
                                  font: buttonFont,
                                  cornerRadius: 40/2,
                                  backgroundColor: UIColor(hexString: "#E13939"))
        volenteer.configure(color: backgroundColor,
        font: buttonFont,
        cornerRadius: 40/2,
        backgroundColor: UIColor(hexString: "#69477C"))
       client.configure(color: backgroundColor,
        font: buttonFont,
        cornerRadius: 40/2,
        backgroundColor: UIColor(hexString: "#E1BD39"))

        staff.configure(color: backgroundColor,
        font: buttonFont,
        cornerRadius: 40/2,
        backgroundColor: UIColor(hexString: "#388724"))
        
  
        
       staff.addTarget(self, action: #selector(didTapStaffButton), for: .touchUpInside)
}
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
}

  
override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)

  }
    @objc private func didTapStaffButton() {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "staffViewController") as! staffViewController
      self.navigationController?.pushViewController(myVC, animated: true)
    }
    @objc func didTapBackButton() {
        
        let context = appdelegate.persistentContainer.viewContext

       let temp = self.item[0] as! NSManagedObject
       let userNAME = temp.value(forKey: "email")
       
       let entitydec = NSEntityDescription.entity(forEntityName: "User", in:  appdelegate.persistentContainer.viewContext)
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
       request.entity = entitydec
       let pred = NSPredicate(format: "email = %@", userNAME as! CVarArg)
       request.predicate = pred
       do
       {
           let result = try context.fetch(request)
           if result.count > 0
           {
               let manage = result[0] as! NSManagedObject
               context.delete(manage)
               try context.save()
               print("Record Deleted")
           }
           else
           {
               print("Record Not Found")
           }
       }
       catch{}

           let LogoutVC = ATCClassicLandingScreenViewController(nibName: "ATCClassicLandingScreenViewController", bundle: nil)
           self.navigationController?.pushViewController(LogoutVC, animated: true)
       }
}
