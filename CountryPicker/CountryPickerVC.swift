//
//  CountryPickerVC.swift
//  JabyJob
//
//  Created by DMG swift on 18/01/22.
//

import UIKit

protocol countryPhoneCode {
    func countryCode(countryId:[String:Any])
}
protocol countryName{
    func countryName(countryId:[String:Any])
    func multipalCountryName(countryNames:[[String:Any]])
    
}


class CountryPickerVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return countriesData.count
        if(searching == true){
            if searchArrRes.count > 0{
                tblCountry.backgroundView = nil
                return searchArrRes.count
            }else {
                
                self.tblCountry.setEmptyMessage("No data found")
            }
            
        }else{
            if countryModalView.showCountryData.count > 0{
                tblCountry.backgroundView = nil
                return countryModalView.showCountryData.count
            }else {
                
                if countryModalView.isdataShow == true{
                    self.tblCountry.setEmptyMessage("No data found")
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tblCountry.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        if isCountryName == true {
//            cell.lblleadaingConst.constant = -40
//            cell.lblCountryCode.isHidden = true
        }else {
//            cell.lblleadaingConst.constant = 16
//            cell.lblCountryCode.isHidden = false
        }
        if( searching == true){
            
            if searchArrRes.count > 0{
                
                cell.lblCountryName.text = searchArrRes[indexPath.row]["name"] as? String ?? ""
                //                cell.countryImg.image = searchArrRes[indexPath.row].flag.image()
                cell.lblCountryCode.text = "+ " +  "\(searchArrRes[indexPath.row]["phonecode"] ?? 0)"
            }
        }else {
          
            cell.lblCountryName.text = countryModalView.showCountryData[indexPath.row]["name"] as? String ?? ""
            
            cell.lblCountryCode.text = "+ " +  "\(countryModalView.showCountryData[indexPath.row]["phonecode"] ?? 0)"
//            cell.lblCountryCode
            
        }
        
//        if UserDefaultData.value(forKey: "user") as? Int == 2 || userRoll == 2 {
//            cell.accessoryType = .none
//        }else {
            
            if( searching == true){
                if self.searchArrRes[indexPath.row]["isSelect"] as? Bool == false {
                    cell.accessoryType = .none
                }else {
                    cell.accessoryType = .checkmark
                }
            }else {
                if countryModalView.showCountryData[indexPath.row]["isSelect"] as? Bool == false {
                    cell.accessoryType = .none
                }else {
                    cell.accessoryType = .checkmark
                }
            }
//        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isCountryName == false {
            if( searching == true ) {
                if UserDefaultData.value(forKey: "user") as? Int == 2 {
                    if self.searchArrRes.count > 0{
                        print(self.searchArrRes[indexPath.row])
                        self.delegateCountryCode?.countryCode(countryId: self.searchArrRes[indexPath.row])
                    }
                    updateCounty()
                    self.dismiss(animated: false, completion: nil)
                    //                    self.dismiss(animated: false) {
                    //                        print(self.sendData)
                    //
                    //                    }
                }else {
                    
                    if self.searchArrRes.count > 0{
                        print(self.searchArrRes[indexPath.row])
                        self.delegateCountryCode?.countryCode(countryId: self.searchArrRes[indexPath.row])
                    }
                    updateCounty()
                    self.dismiss(animated: false, completion: nil)
                }
                
            } else {
                if UserDefaultData.value(forKey: "user") as? Int == 2 {
                    self.dismiss(animated: false) {
                        self.delegateCountryCode?.countryCode(countryId: self.countryModalView.showCountryData[indexPath.row])
                    }
                }else {
                    self.dismiss(animated: false) {
                        
                        self.delegateCountryCode?.countryCode(countryId: self.countryModalView.showCountryData[indexPath.row])
                        
//                        self.delegageCountryName?.countryName(countryId: self.countryModalView.showCountryData[indexPath.row])
                        
                    }
                }
                
                
            }
        }else {
            
            
            if( searching == true ) {
                if self.searchArrRes[indexPath.row]["isSelect"] as? Bool == false {
                    let id = self.searchArrRes[indexPath.row]["id"] as? Int
                    searchDataIds.append(id ?? 0)
                    self.searchArrRes[indexPath.row]["isSelect"] = true
                    updateCounty()
                }else {
                    
                    let id =  self.searchArrRes[indexPath.row]["id"] as? Int ?? 0
                    for i in 0..<self.searchDataIds.count {
                        if self.searchDataIds[i] == id {
                            self.searchDataIds.remove(at: i)
                            self.searchArrRes[indexPath.row]["isSelect"] = false
                            break;
                        }
                    }
                    updateCounty()
                }
                
            }else {
                if countryModalView.showCountryData[indexPath.row]["isSelect"] as? Bool == false {
                    let id = countryModalView.showCountryData[indexPath.row]["id"] as? Int
                    searchDataIds.append(id ?? 0)
                    countryModalView.showCountryData[indexPath.row]["isSelect"] = true
                }else {
                    
                    let id = countryModalView.showCountryData[indexPath.row]["id"] as? Int ?? 0
                    
                    for i in 0..<self.searchDataIds.count {
                        
                        if self.searchDataIds[i] == id {
                            self.searchDataIds.remove(at: i)
                            break;
                        }
                    }
                    countryModalView.showCountryData[indexPath.row]["isSelect"] = false
                }
            }
            tblCountry.reloadData()
        }
    }
    
    var countriesData = [(name: String, flag: String)]()
    @IBOutlet weak var tblCountry: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    //    var searchArrRes =  [(name: String, flag: String)]()
    var searchArrRes = [[String:Any]]()
    var searching:Bool = false
    var countryModalView = CountryViewModal()
    var delegateCountryCode: countryPhoneCode? = nil
    var delegageCountryName: countryName? = nil
    var sendData = [[String:Any]]()
    var isCountryName = false
    var isSTrue = false
    var priviousSelectdData = [Int]()
    var searchDataIds = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSearch.delegate = self
        countryModalView.VC = self
        countryModalView.countryDataApi()
        self.searchDataIds = priviousSelectdData
        /// 'All Country name and flag'
        for code in NSLocale.isoCountryCodes  {
            
            let flag = String.emojiFlag(for: code)
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            
            if let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) {
                countriesData.append((name: name, flag: flag!))
            }else{
                //"Country not found for code: \(code)"
            }
        }
        /// 'set country flag'
        //       _ = countriesData.compactMap { list in
        //            if list.name == countryName{
        //               flagimg.image = list.flag.image()
        //            }
        //        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //input text
        let searchText  = textField.text! + string
        print("searchText",searchText)
        //add matching text to arrya
        
        self.searchArrRes.removeAll()
        if searchText.count > 0 {
            
            //            DispatchQueue.main.sync {
            for index in 0..<countryModalView.showCountryData.count {
                let value = countryModalView.showCountryData[index]["name"] as? String ?? ""
                
                if value.lowercased().contains(searchText){
                    //                    print("sdfasd",value)
                    
                    for index in 0..<countryModalView.showCountryData.count{
                        let subCatName = countryModalView.showCountryData[index]["name"] as? String ?? ""
                        if subCatName == value {
                            print("searchArrRes",countryModalView.showCountryData[index])
                            
                            self.searchArrRes.append(countryModalView.showCountryData[index])
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
        
//        updateCounty()
        
        
        self.tblCountry.reloadData()
        
        return true
    }
    
    func updateCounty(){
        
        for i in 0..<countryModalView.showCountryData.count {
            
            let value = countryModalView.showCountryData[i]["id"] as? Int ?? 0
            
            self.searchDataIds.compactMap { listId in
                if listId == value{
                    print("CountryNameDinesh",self.countryModalView.showCountryData[i]["name"])
                    self.countryModalView.showCountryData[i]["isSelect"] = true
                    
                }
            }
        }
    }
    
    @IBAction func didTapdone(_ sender:UIButton){
        
        if isCountryName == true {
            
            var cData = [[String:Any]]()
            
            for i in 0..<self.countryModalView.showCountryData.count {
                if self.countryModalView.showCountryData[i]["isSelect"] as? Bool == true {
                    cData.append(self.countryModalView.showCountryData[i])
                }
                self.delegageCountryName?.multipalCountryName(countryNames: cData)
            }
            
            self.dismiss(animated: false, completion: nil)
        }else {
            self.dismiss(animated: false, completion: nil)
        }
    }
}


class CountryCell:UITableViewCell {
    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblleadaingConst: NSLayoutConstraint!
}
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
