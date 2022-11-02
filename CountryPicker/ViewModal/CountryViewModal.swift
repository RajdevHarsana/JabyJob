//
//  CountryViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 02/02/22.
//

import Foundation
import NVActivityIndicatorView
import UIKit




class CountryViewModal {
    weak var VC: CountryPickerVC?
    var countryRowData = [CountryModal]()
    var countryData = JsonDict()
    var showCountryData = [[String:Any]]()
    var isdataShow = false
    let (blurView,activityIndicatorView) = Helper.getLoaderViews()
   
    func countryDataApi(){
//      var person = Person()
//        print(person.name)
        self.showCountryData.removeAll()
        ApiClass().countryApi(view: (VC?.view)!, BaeUrl:baseUrl+"country", paramters: [:]) { result in
            print(result)
            self.countryData = result as? [String:Any] ?? [:]
            self.showCountryData = self.countryData["data"] as? [[String:Any]] ?? [[:]]
            
            if self.countryData["status"] as? Int ?? 0 == 0 {
                self.isdataShow = true
            }else {
                self.isdataShow = false
            }
            
            for i in 0..<self.showCountryData.count {
                
                if self.VC?.priviousSelectdData.count ?? 0 > 0 {
                    let id = self.showCountryData[i]["id"] as! Int
                    let priviousId =  self.VC?.priviousSelectdData
                    if priviousId!.contains(id){
                       self.showCountryData[i]["isSelect"] = true
                    }else {
                        self.showCountryData[i]["isSelect"] = false
                    }
                }else {
                    self.showCountryData[i]["isSelect"] = false
                }
            }
            self.VC?.tblCountry.reloadData()
        }
    }
}
