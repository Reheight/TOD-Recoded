//
//  SettingsSections.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/30/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import SCSDKLoginKit
import UIKit
import SCSDKBitmojiKit

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible
{
    case Account
    case Application
    case Copyright
    
    var description: String {
        switch self {
        case .Account: return "Account"
        case .Application: return "Application"
        case .Copyright: return "Copyright 2019 Dustin Palmatier"
        }
    }
}

enum AccountOptions: Int, CaseIterable, CustomStringConvertible, SectionType {
    case refreshBitmoji
    case editProfile
    case health
    case logout
    
    var containsSwitch: Bool { return false }
    
    func action() {
        switch self {
        case .refreshBitmoji:
            break
        case .editProfile:
            break
        case .health:
            break
        case .logout:
            SCSDKLoginClient.clearToken()
        }
    }
    
    var shouldLaunchView: Bool {
        switch self {
        case .refreshBitmoji:
            return true
        case .editProfile:
            return true
        case .health:
            return true
        case .logout:
            return true
        }
    }
    
    var viewLaunched: Int {
        switch self {
        case .refreshBitmoji:
            return 2
        case .editProfile:
            return 0
        case .health:
            return 1
        case .logout:
            return 2
        }
    }
    
    var description: String {
        switch self {
        case .refreshBitmoji: return "Refresh Bitmoji"
        case .editProfile: return "Edit Profile"
        case .health: return "Account Health"
        case .logout: return "Logout"
        }
    }
}

enum ApplicationOptions: Int, CaseIterable, CustomStringConvertible, SectionType {
    case notifications
    case reportCrashes
    
    var containsSwitch: Bool {
        switch self {
        case .notifications: return true
        case .reportCrashes: return true
        }
    }
    
    var description: String {
        switch self {
        case .notifications: return "Notifications"
        case .reportCrashes: return "Report Crashes"
        }
    }
}


// MARK: - Account Settings

enum AccountsSection: Int, CaseIterable, CustomStringConvertible {
    case emailAddress
    case phoneNumber
    case externalID
    case disableAccount
    
    var description: String {
        switch self {
        case .emailAddress: return "Email Address"
        case .phoneNumber: return "Phone Number"
        case .externalID: return "External Identifier"
        case .disableAccount: return "Disable Account"
        }
    }
}

enum EmailOption: Int, CaseIterable, CustomStringConvertible, SectionType {
    case email
    
    var containsSwitch: Bool {
        switch self {
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case .email: return "Unavailable"
        }
    }
}

enum PhoneOption: Int, CaseIterable, CustomStringConvertible, SectionType {
    case phone
    
    var containsSwitch: Bool {
        switch self {
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case .phone: return formattedNumber(number: DataStructure.sharedInstance.getPhoneNumber())
        }
    }
}

enum IDOption: Int, CaseIterable, CustomStringConvertible, SectionType {
    case id
    
    var containsSwitch: Bool {
        switch self {
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case .id: return DataStructure.sharedInstance.getExternalId()
        }
    }
}

enum DisableOption: Int, CaseIterable, CustomStringConvertible, SectionType {
    case disable
    
    var containsSwitch: Bool {
        switch self {
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case .disable: return "Disable Account"
        }
    }
}

func formattedNumber(number: String) -> String {
    let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let mask = "+X (XXX) XXX-XXXX"

    var result = ""
    var index = cleanPhoneNumber.startIndex
    for ch in mask where index < cleanPhoneNumber.endIndex {
        if ch == "X" {
            result.append(cleanPhoneNumber[index])
            index = cleanPhoneNumber.index(after: index)
        } else {
            result.append(ch)
        }
    }
    return result
}


func getPhoneNumber() {
    let postString = "externalid=\(DataStructure.sharedInstance.getExternalId())"
    
    let url = URL(string: "https://truthordare.hexhamnetwork.com/api/92fFDd93D/retrieveNumber.php")!
    
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
                        DataStructure.sharedInstance.setPhoneNumber(string: "Unavailable")
                    } else {
                        let status = parseJSON["status"] as? String
                        
                        if (status! == "unset") {
                            DataStructure.sharedInstance.setPhoneNumber(string: "Unavailable")
                        } else {
                            let number = parseJSON["number"] as? String
                            DataStructure.sharedInstance.setPhoneNumber(string: number ?? "We hit a snag!")
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
