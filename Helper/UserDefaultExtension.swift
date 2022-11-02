//
//  UserDefaultExtension.swift
//  JabyJob
//
//  Created by DMG swift on 24/01/22.
//

import Foundation



let UserDefaultData = UserDefaults.standard


public func userDataShow(userdata:String)->[String:Any]{
    return UserDefaults.standard.value(forKey: userdata) as? [String:Any] ?? [:]
}

//defaults.set(25, forKey: "Age")
//defaults.set(true, forKey: "UseTouchID")
//defaults.set(CGFloat.pi, forKey: "Pi")
//
//defaults.set("Paul Hudson", forKey: "Name")
//defaults.set(Date(), forKey: "LastRun")
