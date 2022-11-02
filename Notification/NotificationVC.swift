//
//  NotificationVC.swift
//  JabyJob
//
//  Created by DMG swift on 24/01/22.
//

import UIKit
import TTGSnackbar

class NotificationVC: BaseViewController {
    @IBOutlet weak var tblNotification:UITableView!
     var deletePlanetIndexPath: NSIndexPath? = nil
    private var notificationListData = [NotificationModal]()
    private var token = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        getNotificationListApi()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    @IBAction func BtndidTapBack(_ sender:UIButton) {
        self.dismiss(animated: true) {
            let objToBeSent = true
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        }
//        self.navigationController?.popViewController(animated: false)
    }
    private func getNotificationListApi(){
        ApiClass().notificationsList(view: self.view, inputUrl: baseUrl+"get-notification", parameters: [:], header: token) { result in
            print(result)
            
            let data = result as? NotificationModal
            if data?.data?.notification?.count ?? 0 > 0 {
                self.notificationListData.removeAll()
                self.notificationListData.append(result as! NotificationModal)
                self.tblNotification.reloadData()
                self.tblNotification.beginUpdates()
            }
           
        }
    }

}

extension NotificationVC: UITableViewDelegate,UITableViewDataSource{
    
       
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
                // weak self to prevent memory leak if needed
                guard let self = self else { return }
            let param = ["id":self.notificationListData[0].data?.notification?[indexPath.row].id ?? 0] as JsonDict
            ApiClass().notificationsRemove(view: self.view, inputUrl: baseUrl+"delete-notification", parameters: param, header:self.token) { result in
                let dict = result as? JsonDict
                let snackbar = TTGSnackbar(message:dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                self.getNotificationListApi()
                
//                print(result)
            }
                completion(true)
            }
            
            deleteAction.backgroundColor = UIColor(named: "blueColor")
//            deleteAction.image = UIImage(systemName: "trash")
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationListData.count > 0 {
            self.tblNotification.backgroundView = nil
            return notificationListData[0].data?.notification?.count ?? 0
        }else {
                self.tblNotification.setEmptyMessage("No data found")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        
        if indexPath.row == 0 || indexPath.row == 1 {
            if indexPath.row == 1{
                cell.bgView.roundCorners([.bottomLeft], radius: 60)
            }
            cell.bgView.backgroundColor = #colorLiteral(red: 0.04369666427, green: 0.2841187716, blue: 0.5517216921, alpha: 1)
        }else {
            cell.bgView.backgroundColor = .white
            cell.lbldes.textColor = #colorLiteral(red: 0.1665197313, green: 0.1045259908, blue: 0.2227908373, alpha: 1)
            cell.lbltime.textColor = #colorLiteral(red: 0.603345871, green: 0.562095046, blue: 0.6369097829, alpha: 1)
            cell.bgView.roundCorners([.bottomLeft], radius: 0)
        }
        cell.lbldes.text = self.notificationListData[0].data?.notification?[indexPath.row].message
        
//        cell.lblTitle.text = searchData[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


class NotificationCell:UITableViewCell {
    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbldes: UILabel!
    @IBOutlet weak var lbltime: UILabel!
}
