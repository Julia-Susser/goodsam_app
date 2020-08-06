//
//  ATCClassicLoginScreenViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit
import CoreData
class ATCClassicLoginScreenViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var contactPointTextField: ATCTextField!
    @IBOutlet var loginButton: UIButton!

   
    @IBOutlet var backButton: UIButton!

    
    
    
   
    
    
    
    
    private let backgroundColor: UIColor = .white
    private let tintColor: UIColor = .orange

    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)

    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let textFieldColor = UIColor(hexString: "#B0B3C6")
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")

    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")
let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(UIImage.localImage("arrow-back-icon", template: true), for: .normal)
        backButton.tintColor = UIColor(hexString: "#282E4F")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        titleLabel.font = titleFont
        titleLabel.text = "Log In"
        titleLabel.textColor = tintColor

        contactPointTextField.configure(color: textFieldColor,
                                        font: textFieldFont,
                                        cornerRadius: 55/2,
                                        borderColor: textFieldBorderColor,
                                        backgroundColor: backgroundColor,
                                        borderWidth: 1.0)
        contactPointTextField.placeholder = "E-mail"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true

        passwordTextField.configure(color: textFieldColor,
                                font: textFieldFont,
                                cornerRadius: 55/2,
                                borderColor: textFieldBorderColor,
                                backgroundColor: backgroundColor,
                                borderWidth: 1.0)
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true

        

        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)

        
        
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
    func contact(){ let email: String = contactPointTextField.text ?? "null"
    }
    @objc func didTapLoginButton() {
        let loginManager = FirebaseAuthManager()
        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                self.contact()
                
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

  

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
}
