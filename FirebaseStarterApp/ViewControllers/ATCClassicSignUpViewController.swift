//
//  ATCClassicSignUpViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit
import CoreData
import FirebaseFirestore
class ATCClassicSignUpViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameTextField: ATCTextField!
    
    @IBOutlet var phoneNumberTextField: ATCTextField!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var emailTextField: ATCTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!

    private let tintColor: UIColor = .orange
    private let backgroundColor: UIColor = .white
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(hexString: "#282E4F")
        backButton.tintColor = color
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        titleLabel.font = titleFont
        titleLabel.text = "Sign Up"
        titleLabel.textColor = tintColor

        nameTextField.configure(color: textFieldColor,
                                font: textFieldFont,
                                cornerRadius: 40/2,
                                borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        nameTextField.placeholder = "Full Name"
        nameTextField.clipsToBounds = true

        emailTextField.configure(color: textFieldColor,
                                 font: textFieldFont,
                                 cornerRadius: 40/2,
                                 borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        emailTextField.placeholder = "E-mail Address"
        emailTextField.clipsToBounds = true

        phoneNumberTextField.configure(color: textFieldColor,
                                       font: textFieldFont,
                                       cornerRadius: 40/2,
                                       borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.clipsToBounds = true

        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 40/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.clipsToBounds = true

        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: backgroundColor,
                               font: buttonFont,
                               cornerRadius: 40/2,
                               backgroundColor: UIColor(hexString: "#ce652d"))

        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }


    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    func email(){ let email: String = emailTextField.text ?? "null"
    }
    @objc func didTapSignUpButton() {
        let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    let db = Firestore.firestore()
                    let job = "Staff"
                    self.email()
                    let name: String = self.nameTextField.text ?? "null"
                    db.collection("users").addDocument(data: [
                        "email": email,
                        "name": name,
                        "job" : job
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            
                            print("Document added with ID: ")
                            
                        }
                    }
                    
                    db.collection("users").document("users").setData([
                        email:name
                        
                    ], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    let entity = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.nscontext)
                    entity.setValue(email, forKey:"email")
                    entity.setValue(Date(), forKey:"lastLoggedIn")
                    
                    do
                    {
                        try self.nscontext.save()
                        
                        

                    }
                    catch
                    {
                    }
                        
                    
                    let storyboard = UIStoryboard(name: "main", bundle: nil)

                    let myVC = storyboard.instantiateViewController(withIdentifier: "mainViewController") as! mainViewController
                    self.navigationController?.pushViewController(myVC, animated: true)

                } else {
                    message = "There was an error."
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                   alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                   self.display(alertController: alertController)
                }
               
            }
        }
    }

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
