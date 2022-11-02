//
//  InterestViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 08/02/22.
//

import Foundation
class InterestViewModal {
    weak var VC: InterestSelectionVC?
    var categoryData = [[String:Any]]()
    
    func categoryApi(){
        ApiClass().categoryApi(view: (VC?.view)!, BaeUrl: baseUrl+"category", paramters: [:]) { result in
            
            let dict = result as? [String:Any] ?? [:]
            self.categoryData = dict["data"] as? [[String:Any]] ?? [[:]]
            
            for i in 0..<self.categoryData.count {
                self.categoryData[i]["isSelect"] = false
                if self.categoryData[i]["title"] as? String ?? "" == "General" {
                    self.categoryData.insert(self.categoryData[i], at: 0)
                    self.categoryData.remove(at:i+1)
                   
                   }
            }
            
            self.VC?.InterestColl.reloadData()
        }
    }
}
