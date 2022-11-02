//
//  OtherUserInfoVC.swift
//  JabyJob
//
//  Created by DMG swift on 06/04/22.
//

import UIKit
import Alamofire

class OtherUserInfoVC: UIViewController {
    var idUser = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        getOtherUserInfoApi()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnDidTapBack(_ sender: UIButton) {
        self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
//        self.dismiss(animated: true, completion: nil)
    }

    private func getOtherUserInfoApi(){
     let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        let param = ["id":idUser] as JsonDict
        let headers : HTTPHeaders = [
            "Authorization":"Bearer " + userToken]
        
        Alamofire.request(baseUrl+"another-profile", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                        print(response)
//                        let data = response.value as? JsonDict
//                        let skills = data?["skill"] as? [[String:Any]]
//                        self.otherVideoListData = data?["video"] as? [[String:Any]] ?? [[:]]
//
//                        if skills?.count ?? 0 > 0 {
//                            skills?.compactMap({ list in
//                                let listData = list["skill"] as? JsonDict
//                                let name = listData?["name"] as? String
//                                print(name)
//                                self.skills.append(name ?? "")
//
//                            })
//                        }
//
//                        self.videoColl.reloadData()
                        
                        break
                    case .failure:
                        print(Error.self)
                    }
                }
        }

}
