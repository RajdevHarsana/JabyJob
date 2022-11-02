//
//  SkillsViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 08/02/22.
//

import Foundation

class SkillsViewModal {
    var isdataShow = false
    weak var VC: SkillsVC?
    var skillData = [[String:Any]]()
    func skillApi()  {
        let param = ["category_id":VC?.catId]
        ApiClass().skillApi(view: (VC?.view)!, BaeUrl: baseUrl+"skill", paramters: param as JsonDict) { result in
            print(result)
            let dict = result as? [String:Any] ?? [:]
            if dict["status"] as? Int ?? 0 == 0 {
                self.isdataShow = true
            }else {
                self.isdataShow = false
            }
            
           
            if dict["status"] as? Int ?? 0 == 1 {
                self.skillData = dict["data"] as? [[String:Any]] ?? [[:]]
                if self.skillData.count > 0  {
                    for i in 0..<self.skillData.count {
                        self.skillData[i]["isSelect"] = false
                    }
                }
            }
            self.VC?.InterestColl.reloadData()
        }
    }
    
    
}
