//
//  Country.swift
//  PhoneNumberPicker
//
//  Created by Hugh Bellamy on 06/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import Foundation

public func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.countryCode == rhs.countryCode
}

public class Country: NSObject {
    public static var emptyCountry: Country { return Country(countryCode: "", phoneExtension: "", isMain: true) }
    
    public static var currentCountry: Country {
        
        
        //NSLocale.value(forKey: NSLocale.Key.countryCode)
        
        if let countryCode = Locale.current.regionCode/*NSLocale.value(forKey: NSLocale.Key.countryCode.rawValue) as? String*/ {
            print(countryCode)
            return Countries.countryFromCountryCode(countryCode)
        }
        
        
        
        return Country.emptyCountry
    }
    
    public var countryCode: String
    public var phoneExtension: String
    public var isMain: Bool
    
    public init(countryCode: String, phoneExtension: String, isMain: Bool) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
        self.isMain = isMain
    }
    
    @objc public var name: String {
        
        //Locale.current.regionCode
        
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.countryCode, value: countryCode) ?? "Invalid country code"
        //return Locale.current.displayName(forKey: Locale.Key.countryCode, value: countryCode) ?? "Invalid country code"
    }
}
