//
//  accountViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/31/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import FirebaseAuth
import PMAlertController
import SCLAlertView
import SCSDKLoginKit

private let reuseIdentifier = "SettingsCell"

class accountViewController: UIViewController, PhoneNumberViewControllerDelegate {
    // MARK: - Properties
    
    var tableView: UITableView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        configureTableView()
    }
    
    func configureUI() {
        navigationItem.title = "Edit Profile"
        
    }
    
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPhoneNumber()
        configureUI()
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

extension accountViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AccountsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = AccountsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .emailAddress: return EmailOption.allCases.count
        case .phoneNumber: return PhoneOption.allCases.count
        case .externalID: return IDOption.allCases.count
        case .disableAccount: return DisableOption.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.text = AccountsSection(rawValue: section)?.description
        title.textColor = .white
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = AccountsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .emailAddress:
            let email = EmailOption(rawValue: indexPath.row)
            cell.sectionType = email
        case .phoneNumber:
            let phone = PhoneOption(rawValue: indexPath.row)
            cell.sectionType = phone
        case .externalID:
            let ID = IDOption(rawValue: indexPath.row)
            cell.sectionType = ID
        case .disableAccount:
            let disable = DisableOption(rawValue: indexPath.row)
            cell.sectionType = disable
        
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = AccountsSection(rawValue: indexPath.section) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        switch section {
        case .phoneNumber:
            presentPhoneChange()
        case .disableAccount:
            presentDisable()
        default: break
        }
    }
    
    
    func presentDisable() {
        let alertVC = PMAlertController(title: "Warning", description: "This will prevent your account from receiving messages, and you will not longer be able to use Truth or Dare, until you choose to reactivate it. You will not be able to view old message or be able to remove the Email or Phone number from your account or use them on a new account!", image: nil, style: .alert)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Type 'I agree' to continue!"
        }
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: nil))
        

        alertVC.addAction(PMAlertAction(title: "Disable", style: .default, action: { () in
            if (alertVC.textFields[0].text == "I agree") {
                self.disableAccount()
                DispatchQueue.main.async {
                    let successAlert: SCLAlertViewResponder = SCLAlertView().showSuccess("Action Complete!", subTitle: "You have disabled your account!")
                    successAlert.setDismissBlock {
                        SCSDKLoginClient.clearToken()
                        let home:UIViewController = (self.storyboard?.instantiateViewController(identifier: "initializerView") as UIViewController?)!
                        home.modalPresentationStyle = .fullScreen
                        self.present(home, animated: true)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let errorAlert: SCLAlertViewResponder = SCLAlertView().showError("Action Cancelled!", subTitle: "You must type 'I agree' to disable your account!")
                }
            }
        }))

        

        self.present(alertVC, animated: true, completion: nil)
    }
    
    func disableAccount() {
        let postString = "externalid=\(DataStructure.sharedInstance.getExternalId())"
        
        let url = URL(string: "https://truthordare.hexhamnetwork.com/api/92fFDd93D/disableAccount.php")!
        
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
        
        
    }
    
    //present
    func presentPhoneChange(){
        let phoneNumberViewController = PhoneNumberViewController.standardController()
        phoneNumberViewController.delegate = self
        navigationController?.pushViewController(phoneNumberViewController, animated: true)
    }
    
    func phoneNumberViewControllerDidCancel(_ phoneNumberViewController: PhoneNumberViewController) {
        self.navigationController?.popViewController(animated: true)
        
    }

    func phoneNumberViewController(_ phoneNumberViewController: PhoneNumberViewController, didEnterPhoneNumber phoneNumber: String) {
        self.navigationController?.popViewController(animated: true)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            return
          }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
            DispatchQueue.main.async {
                let confirm:UIViewController = (self.storyboard?.instantiateViewController(identifier: "confirmNumberView") as ConfirmNumberViewController?)!
                self.navigationController?.pushViewController(confirm, animated: true)
                
            }
        }
    }
}

