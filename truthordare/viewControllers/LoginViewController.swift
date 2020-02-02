//
//  LoginViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/28/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.clipsToBounds = true
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 15
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.authenticateSnapchat))
        loginButton.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func authenticateSnapchat() {
        SCSDKLoginClient.login(from: ViewController()) { (Bool, Error) in
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    let confirmation:UIViewController = (self.storyboard?.instantiateViewController(identifier: "loginConfirmView") as UIViewController?)!
                    confirmation.isModalInPresentation = true
                    self.present(confirmation, animated: true)
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
