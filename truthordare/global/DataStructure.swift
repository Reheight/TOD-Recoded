//
//  SharedInstance.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/28/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

class DataStructure {
    static var sharedInstance = DataStructure()
    
    private var displayName:String, externalId:String, phoneNumber: String;
    
    private init() {
        displayName = "3940ejfkfi9483jro39ut43jti943uh94u3hrif9ru3h4"
        externalId = "error"
        phoneNumber = "We hit a snag!"
    }
    
    func getPhoneNumber() -> String {
        return self.phoneNumber
    }
    
    func getDisplayName() -> String {
        return self.displayName
    }
    
    func getExternalId() -> String {
        return self.externalId
    }
    
    func setDisplayName(string:String) {
        displayName = string
    }
    
    func setExternalId(string:String) {
        externalId = string
    }
    
    func setPhoneNumber(string:String) {
        phoneNumber = string
    }
}
