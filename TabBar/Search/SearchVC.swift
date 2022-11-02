//
//  SearchVC.swift
//  JabyJob
//
//  Created by DMG swift on 21/01/22.
//

import UIKit

class SearchData {
    
    var title: String?
    var isSelect = false
    init(title: String?) {
        self.title = title
    }
}


class SearchVC: BaseViewController,UITextFieldDelegate {
//var searchData = [SearchData]()
    
    var categoryData = [[String:Any]]()
    var searchArrRes = [[String:Any]]()
    @IBOutlet weak var tblSearch:UITableView!
    @IBOutlet weak var txtSearch:UITextField!
    @IBOutlet weak var lblJob:PaddingLabel1!
    @IBOutlet weak var lblAplicant:PaddingLabel1!
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var filterView:UIView!
    @IBOutlet weak var jobCheck:UIImageView!
    @IBOutlet weak var applicantCheck:UIImageView!
    var searching:Bool = false
    private var roleid = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryApi()
        filterView.isHidden = true
        searchView.isHidden = false
        txtSearch.delegate = self
        searchView.isHidden = false
        
        applicantCheck.image = UIImage(named: "")
        jobCheck.image = UIImage(named: "")
        lblJob.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        lblJob.textColor = #colorLiteral(red: 0.04313013703, green: 0.04314123839, blue: 0.04312635213, alpha: 1)
        lblAplicant.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        lblAplicant.textColor = #colorLiteral(red: 0.04313013703, green: 0.04314123839, blue: 0.04312635213, alpha: 1)
      
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: false)
     
    }
    
    @IBAction func didTapFilter(_sender:UIButton){
        
        filterView.isHidden = false
        searchView.isHidden = true
    }
    
    @IBAction func didTapApply(_sender:UIButton){
        filterView.isHidden = true
        searchView.isHidden = false
    }
    
    @IBAction func didTapJobSeeker(_sender:UIButton){
        jobCheck.image = #imageLiteral(resourceName: "check")
        applicantCheck.image = UIImage(named: "")
        lblJob.font = UIFont(name: "Montserrat-Medium", size: 14.0)
        lblJob.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblAplicant.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        lblAplicant.textColor = #colorLiteral(red: 0.04313013703, green: 0.04314123839, blue: 0.04312635213, alpha: 1)
        roleid = 2
    }
    
    @IBAction func didTapAplicant(_sender:UIButton){
        applicantCheck.image = #imageLiteral(resourceName: "check")
        jobCheck.image = UIImage(named: "")
        lblAplicant.font = UIFont(name: "Montserrat-Medium", size: 14.0)
        lblAplicant.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblJob.font = UIFont(name: "Montserrat-Regular", size: 14.0)
        lblJob.textColor = #colorLiteral(red: 0.04313013703, green: 0.04314123839, blue: 0.04312635213, alpha: 1)
        roleid = 3
    }
    
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //input text
        let searchText  = textField.text! + string
        print("searchText",searchText)
        //add matching text to arrya
        
        self.searchArrRes.removeAll()
        if searchText.count > 0 {
            
            //            DispatchQueue.main.sync {
            for index in 0..<categoryData.count {
                let value = categoryData[index]["title"] as? String ?? ""
                
                if value.lowercased().contains(searchText){
                    //                    print("sdfasd",value)
                    
                    for index in 0..<categoryData.count{
                        let subCatName = categoryData[index]["title"] as? String ?? ""
                        if subCatName == value {
                            
                            self.searchArrRes.append(categoryData[index])
                        }
                    }
                }
            }
            //            }
        }
        else {
            self.searchArrRes.removeAll()
        }
        
        if(searchArrRes.count == 0){
            if searchText.count == 1{
                searching = false
            }else {
                searching = true
            }
            print("searchingFlase")
           
        }else{
            print("searchingtrue")
            
            searching = true
        }
      self.tblSearch.reloadData()
        
        return true
    }
    
    
    
    
  private func categoryApi(){
      ApiClass().categoryApi(view: self.view, BaeUrl: baseUrl+"category", paramters: [:]) { result in
            
            let dict = result as? [String:Any] ?? [:]
            self.categoryData = dict["data"] as? [[String:Any]] ?? [[:]]
            
            for i in 0..<self.categoryData.count {
                self.categoryData[i]["isSelect"] = false
                if self.categoryData[i]["title"] as? String ?? "" == "General" {
                    self.categoryData.insert(self.categoryData[i], at: 0)
                    self.categoryData.remove(at:i+1)
                   
                   }
            }
          
          self.tblSearch.reloadData()
        }
    }

  
    // MARK: - Navigation

   
    @IBAction func didTapDismiss(_sender:UIButton){
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: true)
        }
//        self.dismiss(animated: false, completion: nil)
    }
 
}

extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if(searching == true){
            if searchArrRes.count > 0{
                tblSearch.backgroundView = nil
                return searchArrRes.count
            }else {
                
                self.tblSearch.setEmptyMessage("No data found")
            }
            
        }else{
            if categoryData.count > 0{
                tblSearch.backgroundView = nil
                return categoryData.count
            }else {
                
//                if countryModalView.isdataShow == true{
//                    self.tblCountry.setEmptyMessage("No data found")
//                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        
        if( searching == true){
            if searchArrRes.count > 0{
                cell.lblTitle.text = searchArrRes[indexPath.row]["title"] as? String ?? ""
            }
        }else {
            cell.lblTitle.text = categoryData[indexPath.row]["title"] as? String ?? ""
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            let cateData = ["CategoryData":self.categoryData[indexPath.row],"role":self.roleid] as [String : Any] 
            NotificationCenter.default.post(name: Notification.Name("CategoryNotification"), object: nil, userInfo: cateData)
        }
    }
}


class SearchCell:UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
}
@IBDesignable class PaddingLabel1: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
