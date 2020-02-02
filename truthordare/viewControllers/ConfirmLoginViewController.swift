//
//  ConfirmLoginViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/29/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class ConfirmLoginViewController: UIViewController {
    @IBOutlet weak var confirmButton: UIView!
    @IBOutlet weak var cancelButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        confirmButton.layer.borderColor = UIColor.black.cgColor
        confirmButton.clipsToBounds = true
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.cornerRadius = 15
        let tapConfirmGesture = UITapGestureRecognizer(target: self, action: #selector(self.confirm))
        confirmButton.addGestureRecognizer(tapConfirmGesture)
        
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.clipsToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 15
        let tapCancelGesture = UITapGestureRecognizer(target: self, action: #selector(self.cancel))
        cancelButton.addGestureRecognizer(tapCancelGesture)
    }
    
    @objc
    func confirm() {
        DispatchQueue.main.async {
            let home:UIViewController = (self.storyboard?.instantiateViewController(identifier: "initializerView") as UIViewController?)!
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true)
        }
    }
    
    @objc
    func cancel() {
        SCSDKLoginClient.clearToken()
        DispatchQueue.main.async {
            let home:UIViewController = (self.storyboard?.instantiateViewController(identifier: "initializerView") as UIViewController?)!
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true)
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
