//
//  ReportVC.swift
//  JabyJob
//
//  Created by DMG swift on 24/01/22.
//

import UIKit
import TTGSnackbar

//class ReportData {
//
//    var title: String?
//    var isSelect = false
//    init(title: String?) {
//        self.title = title
//    }
//}

class ReportVC: BaseViewController {
    @IBOutlet weak var tblReportr: UITableView!
    @IBOutlet weak var PopupView: UIView!
    @IBOutlet weak var reportPopupView: UIView!
    var videoId = 0
    var reasonid = 0
//    var reportData = [ReportData]()
    var reportdata = [ReportModal]()
//        var data = ["It's spam","Hate speech or symbols","I just don't like it","False information","Bullying or harassment","Scam or Fraud","Something else"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportPopupView.isHidden = true
//        for i in 0..<data.count{
//            reportData.append(ReportData(title: data[i]))
//        }
        
        reportApi()
        let tapView = UITapGestureRecognizer(target: self, action: #selector(didTapDismis))
        self.PopupView.addGestureRecognizer(tapView)
      
        self.tblReportr.RoundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 0)
        
        self.reportPopupView.RoundCorner([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 10.0, borderColor: UIColor.clear, borderWidth: 0)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapDismis(){
        self.dismiss(animated: false, completion: nil)
    }

  
    // MARK: - Navigation
    @IBAction func didTapDismiss(_sender:UIButton){
        reportPopupView.isHidden = true
    }
    @IBAction func didTapSubmit(_sender:UIButton){
        
        submitReportApi()
    }
   
    func submitReportApi(){
        let param = ["video_id":self.videoId,"reason_id":reasonid] as JsonDict
        ApiClass().submitReportApi(view:self.view, inputUrl: baseUrl+"report-video", parameters: param, header: userToken) { result in
            print(result)
            let dict = result as? JsonDict
            self.reportPopupView.isHidden = true
            self.dismiss(animated: true, completion: nil)
            let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
            snackbar.show()
            NotificationCenter.default.post(name: Notification.Name("videoList"), object: true)
//            if dict?["status"] as? Int ?? 0 == 0 {
//
//            }
//            self.reportdata.append(result as! ReportModal)
//            self.tblReportr.reloadData()
        }
    }
    
    
    func reportApi(){
        let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        ApiClass().resoneApi(view:self.view, inputUrl: baseUrl+"reason", parameters: [:], header: userToken) { result in
            print(result)
            self.reportdata.append(result as! ReportModal)
            self.tblReportr.reloadData()
        }
    }
}
extension ReportVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if reportdata.count > 0 {
            return self.reportdata[0].data?.count ?? 0
        }else {
            return 0
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportCell
        cell.lblTitle.text = self.reportdata[0].data?[indexPath.row].reason
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reportPopupView.isHidden = false
        tblReportr.isHidden = true
        reasonid = self.reportdata[0].data?[indexPath.row].id ?? 0
    }
}


class ReportCell:UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
}
