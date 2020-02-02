//
//  ConfirmReactivateViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/29/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class ConfirmReactivateViewController: UIViewController {
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
        let postString = "externalid=\(DataStructure.sharedInstance.getExternalId())"
        
        let url = URL(string: "https://truthordare.hexhamnetwork.com/api/92fFDd93D/activateAccount.php")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
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
