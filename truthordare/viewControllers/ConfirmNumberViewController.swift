//
//  ConfirmNumberViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 2/1/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import PinCodeTextField
import FirebaseAuth
import SCLAlertView

class ConfirmNumberViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var codeTextField: PinCodeTextField!
    
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    let number = UserDefaults.standard.string(forKey: "phoneNumber")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        phoneNumber.layer.borderColor = UIColor.black.cgColor
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.cornerRadius = 2
        codeTextField.delegate = self
        
        phoneNumber.text = formattedNumber(number: number ?? "")
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

extension ConfirmNumberViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        textField.keyboardType = .numberPad
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        textField.keyboardType = .numberPad
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID!,
        verificationCode: textField.text ?? "")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            // ...
            return
          }
            self.setPhoneNumber(number: self.number ?? "")
        }
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func setPhoneNumber(number: String) {
        let postString = "externalid=\(DataStructure.sharedInstance.getExternalId())&number=\(number)"
        
        let url = URL(string: "https://truthordare.hexhamnetwork.com/api/92fFDd93D/setNumber.php")!
        
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
                        let error = parseJSON["error"] as? String
                        if (error == "true") {
                            let message      = parseJSON["message"] as? String
                            DispatchQueue.main.async {
                                let successAlert: SCLAlertViewResponder = SCLAlertView().showNotice("Woah!", subTitle: message ?? "We ran into an issue changing your number!")
                                successAlert.setDismissBlock {
                                    getPhoneNumber()
                                    self.navigationController?.popViewController(animated: true)
                                    self.phoneNumber?.text = formattedNumber(number: DataStructure.sharedInstance.getPhoneNumber())
                                }
                            }
                        } else {
                            let message = parseJSON["message"] as? String
                            
                            DispatchQueue.main.async {
                                let successAlert: SCLAlertViewResponder = SCLAlertView().showSuccess("Success!", subTitle: "Your number has been changed!")
                                successAlert.setDismissBlock {
                                    getPhoneNumber()
                                    self.navigationController?.popViewController(animated: true)
                                    self.phoneNumber?.text = formattedNumber(number: DataStructure.sharedInstance.getPhoneNumber())
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

}
