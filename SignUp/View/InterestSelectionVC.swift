//
//  InterestSelection.swift
//  Demo-push
//
//  Created by Arkamac1 on 06/01/22.
//

import UIKit

class InterestModal {
    var name: String?
    var isSelect = false
    init(name:String) {
        self.name = name
    }
}


class InterestSelectionVC: BaseViewController {
    
    var interestservice = ["General","Child Care","Aerospace & Defense","Consumer Services","Business Services","Marketing","General","Child Care","Aerospace & Defense","Consumer Services","Business Services","Marketing"]
    
    @IBOutlet weak var Btn_Next: UIButton!
    @IBOutlet weak var Btn_Skip: UIButton!
    @IBOutlet weak var InterestColl: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    
    var interestData = [InterestModal]()
    var isgeneralSelected = false
    var interestModalView = InterestViewModal()
    var catid = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showAlert()
        interestModalView.VC = self
        interestModalView.categoryApi()

        
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width-70, height: 40)
        InterestColl.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        
//        let layout = UICollectionViewCenterLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//
//        layout.scrollDirection = .vertical
//        InterestColl.collectionViewLayout = layout
        InterestColl.reloadData()
        btnNext.isUserInteractionEnabled = false
        btnNext.setImage(UIImage(named: "NEXtBlur"), for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    @IBAction func didTapHome(_ sender:UIButton) {
        
        appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
        
    }
    
    @IBAction func didTapNext(_ sender:UIButton) {
        if isgeneralSelected == true{
            
            let storyboard = UIStoryboard(name: "Upload", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UploadVC")
            self.navigationController?.pushViewController(vc, animated: true)
            
//            appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")

        }
    else{
        let storyboard = UIStoryboard(name: "Skill", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SkillsVC") as! SkillsVC
        
      
        
        
        vc.catId = catid
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func didTapSkip(_ sender:UIButton) {
        
        
    }
}

extension InterestSelectionVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestModalView.categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InterestCollCell
        cell.borderview.addShadow(offset: CGSize.init(width: 0, height: 1), color: UIColor.black, radius: 2.0, opacity: 0.35)
//        cell.lbl_service.
//        cell.lbl_service.intrinsicContentSize.width = 100
//        cell.shadowDecorate()
        cell.lbl_service.font = UIFont(name:"Montserrat-Regular", size: 14.0)
        cell.lbl_service.text = interestModalView.categoryData[indexPath.row]["title"] as? String ?? "" //interestData[indexPath.row].name
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        if interestModalView.categoryData[indexPath.row]["isSelect"] as? Bool == true {
            cell.borderview.backgroundColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
            cell.lbl_service.textColor = .white
        }else {
            cell.borderview.backgroundColor = .white
            cell.lbl_service.textColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
        }
        return  cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for i in 0..<interestModalView.categoryData.count {
            if  interestModalView.categoryData[i]["isSelect"] as? Bool == true {
                interestModalView.categoryData[i]["isSelect"] = false
            }
        }

        if interestModalView.categoryData[indexPath.row]["title"] as? String ?? "" == "General (All)"{
            isgeneralSelected = true
        }
        else
        {
            isgeneralSelected = false
        }
        if interestModalView.categoryData[indexPath.row]["isSelect"] as? Bool == true {
            interestModalView.categoryData[indexPath.row]["isSelect"]  = false
            btnNext.isUserInteractionEnabled = false
            btnNext.setImage(UIImage(named: "NEXtBlur"), for: .normal)
        }else {
            interestModalView.categoryData[indexPath.row]["isSelect"] = true
            catid = interestModalView.categoryData[indexPath.row]["id"] as? Int ?? 0
            btnNext.isUserInteractionEnabled = true
            btnNext.setImage(UIImage(named: "NEXT"), for: .normal)
        }
        InterestColl.reloadData()
        
    }

}

