//
//  SkillsVC.swift
//  JabyJob
//
//  Created by Arkamac1 on 12/01/22.
//

import UIKit
import TTGSnackbar

class SkillsVC: BaseViewController {
    
    var interestservice = ["Application Development Architecture Artificial Intelligence","Cloud Computing","HTML","C++","C Language","PHP","UX Design","Python","JavaScript","Java","Ruby"]
    
    @IBOutlet weak var Btn_Next: UIButton!
    @IBOutlet weak var Btn_Skip: UIButton!
    @IBOutlet weak var InterestColl: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    
    var interestData = [InterestModal]()
    var catId = 0
    var ids = [Int]()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    var skillModalView = SkillsViewModal()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showAlert()
        skillModalView.VC = self
        skillModalView.skillApi()
    
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        InterestColl.collectionViewLayout = layout
        InterestColl.reloadData()
        btnNext.isUserInteractionEnabled = false
        btnNext.setImage(UIImage(named: "NEXtBlur"), for: .normal)
    }
    
    @IBAction func didTapHome(_ sender:UIButton) {
       
        appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
        
    }
    
    
    @IBAction func didTapNext(_ sender:UIButton) {
        self.ids.removeAll()
        
        _ = skillModalView.skillData.compactMap { list in
            if list["isSelect"] as? Bool == true {
                ids.append(list["id"] as? Int ?? 0)
            }
        }
        let dict = ["category_id":catId,"skill_id":self.ids] as JsonDict

        ApiClass().updateCatSkillApi(view: self.view, inputUrl: baseUrl+"upload-skill", parameters: dict, header: userToken) { result in
            let dict = result as? JsonDict
            if dict?[""] as? Int ?? 0 == 1 {
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
            }else {

                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                
                let storyboard = UIStoryboard(name: "Upload", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UploadVC")
                self.navigationController?.pushViewController(vc, animated: true)
                       
            }
//            print(resul)
        }
        
        
//        appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
        
        
//        let storyboard = UIStoryboard(name: "Upload", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "UploadVC")
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func didTapSkip(_ sender:UIButton) {
        
        
    }
}

extension SkillsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if skillModalView.skillData.count == 0{
            if skillModalView.isdataShow == true{
                self.InterestColl.setEmptyMessage("No data found")
            }else {
                self.InterestColl.setEmptyMessage("")
            }
        }else {
            self.InterestColl.restore()
            return skillModalView.skillData.count
//            return skillModalView.skillData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InterestCollCell
        cell.borderview.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.black, radius: 2.0, opacity: 0.35)

//        cell.shadowDecorate()
        cell.lbl_service.font = UIFont(name:"Montserrat-Regular", size: 14.0)
        cell.lbl_service.text = skillModalView.skillData[indexPath.row]["name"] as? String ?? ""
        
        
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        if skillModalView.skillData[indexPath.row]["isSelect"] as? Bool == true {

            cell.borderview.backgroundColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
            cell.lbl_service.textColor = .white

        }else {
            cell.borderview.backgroundColor = .white
            cell.lbl_service.textColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
        }
       

        return  cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView,
//                            layout collectionViewLayout: UICollectionViewLayout,
//                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 10
//        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if skillModalView.skillData[indexPath.row]["isSelect"] as? Bool == false {
                skillModalView.skillData[indexPath.row]["isSelect"] = true
                btnNext.isUserInteractionEnabled = true
                btnNext.setImage(UIImage(named: "NEXT"), for: .normal)
        }else {
            skillModalView.skillData[indexPath.row]["isSelect"] = false
        }
        var count = 0
        for i in 0..<skillModalView.skillData.count{
            if skillModalView.skillData[i]["isSelect"] as? Bool == false{
                count += 1
            }
        }
        if skillModalView.skillData.count == count {
            btnNext.isUserInteractionEnabled = false
            btnNext.setImage(UIImage(named: "NEXtBlur"), for: .normal)
        }
        InterestColl.reloadData()
    }

}
