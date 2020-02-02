//
//  ViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/28/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import SCLAlertView

class ViewController: UIViewController {
    @IBOutlet weak var statusBox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBox.layer.cornerRadius = 10
        statusBox.layer.borderWidth = 1
        statusBox.layer.borderColor = UIColor.black.cgColor
        statusBox.clipsToBounds = true
        
        initialize()
    }

    func initialize() {
        let graphQLQuery = "{me{externalId, displayName, bitmoji{avatar}}}"
        
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: nil, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else { return }
            let displayName = me["displayName"] as? String
            let externalId = me["externalId"] as? String
            var bitmojiAvatarUrl: String?
            
            
            let pattern = "[^A-Za-z0-9]+"
            let resultID = externalId?.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
            
            DataStructure.sharedInstance.setExternalId(string: resultID ?? "error")
            DataStructure.sharedInstance.setDisplayName(string: displayName ?? "We ran into an issue!")
            
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = bitmoji["avatar"] as? String
            }
            
            let bitmojiURL = bitmojiAvatarUrl ?? "ERROR"
            
            let postString = "displayname=\(displayName!)&externalid=\(resultID!)&bitmoji=\(bitmojiURL)"
            
            let url = URL(string: "https://truthordare.hexhamnetwork.com/api/92fFDd93D/register.php")!
            
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
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            let maintenance = parseJSON["maintenance"] as? String
                            
                            if (maintenance == "true") {
                                DispatchQueue.main.async {
                                    let maintenanceAlert: SCLAlertViewResponder = SCLAlertView().showNotice("Truth or Dare is unavailable!", subTitle: "Truth or Dare is currently under maintenance!")
                                    maintenanceAlert.setDismissBlock {
                                        exit(1)
                                    }
                                }
                                
                                return
                            }
                            
                            let disabled = parseJSON["disabled"] as? String
                            
                            if (disabled == "true") {
                                DispatchQueue.main.async {
                                    DispatchQueue.main.async {
                                        let login:UIViewController = (self.storyboard?.instantiateViewController(identifier: "ReactivateConfirmView") as UIViewController?)!
                                        login.isModalInPresentation = true
                                        self.present(login, animated: true)
                                    }
                                }
                                
                                return
                            }
                            
                            let banned = parseJSON["banned"] as? String
                            
                            if (banned == "true") {
                                SCSDKLoginClient.clearToken()
                                DispatchQueue.main.async {
                                    let maintenanceAlert: SCLAlertViewResponder = SCLAlertView().showWarning("Truth or Dare is unavailable!", subTitle: "You are banned from Truth or Dare!")
                                    maintenanceAlert.setDismissBlock {
                                        exit(1)
                                    }
                                }
                                
                                return
                            }
                            
                            self.launchMenu()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            print("Failed")
            if (isUserLoggedOut) {
                self.launchLogin()
            } else {
                let errorViewResponder: SCLAlertViewResponder = SCLAlertView().showError("We hit a snag!", subTitle: "We were unable to proceed running the app!")
                
            }
        })
    }
    
    func launchLogin() {
        DispatchQueue.main.async {
            let login:UIViewController = (self.storyboard?.instantiateViewController(identifier: "loginView") as UIViewController?)!
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true )
        }
    }
    
    func launchMenu() {
        DispatchQueue.main.async {
            let menu:UIViewController = (self.storyboard?.instantiateViewController(identifier: "menuView") as UIViewController?)!
            menu.modalPresentationStyle = .fullScreen
            self.present(menu, animated: true)
        }
    }
}

