//
//  Chat.swift
//  JabyJob
//
//  Created by DMG swift on 28/01/22.
//

import UIKit
import SDWebImage

struct ChatList {
    var id: Int?
    var sender: Int?
    var receiver: Int?
    var message: String?
    var file: String?
    var fileType: Int?
    var status: Int?
    var createdAt: String?
//    var count: Int?
    var is_online: Int?
    var full_name: String?
    var image: String?
    
    init(id: Int?,sender: Int?,receiver: Int?,message: String?,file: String?,fileType: Int?,status: Int?,createdAt: String?,is_online: Int?,full_name: String?,image: String?) {
        self.id = id
        self.sender = sender
        self.receiver = receiver
        self.message = message
        self.file = file
        self.fileType = fileType
        self.status = status
        self.createdAt = createdAt
//        self.count = count
        self.is_online = is_online
        self.full_name = full_name
        self.image = image
    }
    
}



class ChatListVC: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var tblChatList:UITableView!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var searchBox:UIView!
    @IBOutlet weak var txtSearch:UITextField!
    @IBOutlet weak var btnClose:UIButton!
    @IBOutlet weak var btnSearch:UIButton!
    @IBOutlet weak var lbltotalUnredMsg:UILabel!
    var userId = Int()
    fileprivate var timer = Timer()
    fileprivate var chatListArr = [ChatList]()
    fileprivate var reciverId = Int()
    fileprivate var searchArrRes = [ChatList]()
    fileprivate var searching:Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        lbltotalUnredMsg.isHidden = true
        btnClose.isHidden = true
        searchBox.isHidden = true
        txtSearch.delegate = self
        topView.roundCorners([.bottomLeft,.bottomRight], radius: 30)
        if UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0 != 0 {
            userId = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        }else {
            userId = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshChatList(_:)), name: NSNotification.Name(rawValue: "refreshChatList"), object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTotalPageCount(_:)), name: NSNotification.Name(rawValue: "gettoalUnreadMsg"), object: nil)
    }
    
    ///'Call after Back'
    @objc func refreshChatList(_ notification: NSNotification) {
        
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: false)
        
        var dict = [String: Any]()
        dict = ["sender": userId]
        SokectIoManager.sharedInstance.establishConnection()
        SokectIoManager.sharedInstance.getChatList(nickname: [dict])
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userChatList(_:)), name: NSNotification.Name(rawValue: "chatList"), object: nil)
        
      
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateCounting()
            })
    }
    
    @IBAction func didtapDismis(_sender:UIButton){
        
        self.dismiss(animated: true) {
            self.timer.invalidate()
                let objToBeSent = true
                NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        }
    }
    
    @IBAction func didtapSearch(_sender:UIButton){
        self.searchBox.isHidden = false
        self.btnSearch.isHidden = true
        self.btnClose.isHidden = false
    }
    @IBAction func didTapClose(_sender:UIButton){
        self.searchBox.isHidden = true
        self.btnSearch.isHidden = false
        self.btnClose.isHidden = true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //input text
        let searchText  = textField.text! + string
        print("searchText",searchText)
        //add matching text to arrya
        
        self.searchArrRes.removeAll()
        if searchText.count > 0 {
            
            //            DispatchQueue.main.sync {
            for index in 0..<chatListArr.count {
                let value = chatListArr[index].full_name ?? ""
                
                if value.lowercased().contains(searchText){
                    //                    print("sdfasd",value)
                    
                    for index in 0..<chatListArr.count{
                        let subCatName = chatListArr[index].full_name ?? ""
                        if subCatName == value {
                            print("searchArrRes",chatListArr[index])
                            self.searchArrRes.append(ChatList(id: chatListArr[index].id ?? 0, sender: chatListArr[index].sender ?? 0, receiver: chatListArr[index].receiver ?? 0, message: chatListArr[index].message ?? "", file: chatListArr[index].file ?? "", fileType: chatListArr[index].fileType ?? 0, status: chatListArr[index].status ?? 0, createdAt: chatListArr[index].createdAt ?? "", is_online: chatListArr[index].is_online ?? 0, full_name: chatListArr[index].full_name ?? "", image: chatListArr[index].image ?? ""))

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
        
        
        self.tblChatList.reloadData()
        
        return true
    }
    
    
    @objc func userChatList(_ notification: NSNotification) {
        print("new message aaya")
        chatListArr.removeAll()
       let data = notification.object as? [String:Any]
        let dict = data?["data"] as? [[String:Any]]
        _ = dict?.compactMap({ list in
            print("new message aaya",list)
            
            let date = list["createdAt"] as? String ?? ""
            let file = list["file"] as? String ?? ""
            let message = list["message"] as? String ?? ""
            let receiver = list["receiver"] as? Int ?? 0
            let sender = list["sender"] as? Int ?? 0
            let status = list["status"] as? Int ?? 0
            let id = list["id"] as? Int ?? 0
            let fileType = list["fileType"] as? Int ?? 0
            let is_online = list["is_online"] as? Int ?? 0
            let full_name = list["full_name"] as? String ?? ""
            let image = list["image"] as? String ?? ""
            
            chatListArr.append(ChatList(id: id, sender: sender, receiver: receiver, message: message, file: file, fileType: fileType, status: status, createdAt: date, is_online: is_online, full_name: full_name, image: image))
            
        })
        
        
        
        tblChatList.reloadData()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: false)
        
        var dict = [String: Any]()
        dict = ["sender": userId]
        SokectIoManager.sharedInstance.establishConnection()
        SokectIoManager.sharedInstance.getChatList(nickname: [dict])
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userChatList(_:)), name: NSNotification.Name(rawValue: "chatList"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTotalPageCount(_:)), name: NSNotification.Name(rawValue: "gettoalUnreadMsg"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getToalUnredMsg(_:)), name: NSNotification.Name(rawValue: "totalUnreadMsg"), object: nil)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateCounting()
            })
        
        
        
    }
    func updateCounting(){
        var dict = [String:Any]()
         dict = ["sender": userId] as JsonDict
        SokectIoManager.sharedInstance.checkUserStataus(dict: dict)
        SokectIoManager.sharedInstance.getChatList(nickname: [dict])
        SokectIoManager.sharedInstance.totalUnreadMsg(dict: dict)
    }
   
    @objc func getTotalPageCount(_ notification: NSNotification) {
        print("dineshGEtOtaolCount",notification.object)
        
    }
    @objc func getToalUnredMsg(_ notification: NSNotification) {
        print("dineshGEtOtaolCount",notification.object as? Int)
        if notification.object as? Int != 0 {
            self.lbltotalUnredMsg.isHidden = false
            self.lbltotalUnredMsg.text = "\(notification.object as? Int ?? 0) new message"
        }else {
            self.lbltotalUnredMsg.isHidden = true
        }
        
//        if notification
        
        
    }

}

extension ChatListVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatListArr.count
        
        if(searching == true){
            if searchArrRes.count > 0{
                tblChatList.backgroundView = nil
                return searchArrRes.count
            }else {
                
                self.tblChatList.setEmptyMessage("No data found")
            }
            
        }else{
            if chatListArr.count > 0{
                tblChatList.backgroundView = nil
                return chatListArr.count
            }else {
                
                    self.tblChatList.setEmptyMessage("No data found")
                
            }
        }
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell

        
        if( searching == true){
            
            if searchArrRes.count > 0{
                
                if searchArrRes.count > 0{
                    if searchArrRes[indexPath.row].is_online == 1 {
                        cell.userStats.isHidden = false
                        cell.userRed.isHidden = false
                    }else {
                        cell.userStats.isHidden = true
                        cell.userRed.isHidden = true
                    }
                        cell.lblMsg.text = searchArrRes[indexPath.row].message ?? ""
                        cell.lblName.text = searchArrRes[indexPath.row].full_name ?? ""
                    cell.userImg.contentMode = .scaleAspectFit
                    cell.userImg.sd_setImage(with: URL(string:(chatImageBaseUrl+(searchArrRes[indexPath.row].image ?? ""))), placeholderImage: UIImage(named: "file-video-icon-256"), options: .refreshCached) { (image, error, cacheType, url) in
            //                    self.userImg.image = image
                    }


                    if searchArrRes[indexPath.row].status == 0 {
                        cell.userRed.isHidden = false
                    }else {
                        cell.userRed.isHidden = true
                    }


                  if searchArrRes[indexPath.row].is_online == 1 {
                        cell.userStats.isHidden = false

                    }else {
                        cell.userStats.isHidden = true
                    }


                }
            }
            }else {
                if chatListArr[indexPath.row].is_online == 1 {
                    cell.userStats.isHidden = false
                    cell.userRed.isHidden = false
                }else {
                    cell.userStats.isHidden = true
                    cell.userRed.isHidden = true
                }
                    cell.lblMsg.text = chatListArr[indexPath.row].message ?? ""
                    cell.lblName.text = chatListArr[indexPath.row].full_name ?? ""
                cell.userImg.sd_setImage(with: URL(string:(chatImageBaseUrl+(chatListArr[indexPath.row].image ?? ""))), placeholderImage: UIImage(named: "file-video-icon-256"), options: .refreshCached) { (image, error, cacheType, url) in
        //                    self.userImg.image = image
                }
                
                
                if chatListArr[indexPath.row].status == 0 {
                    cell.userRed.isHidden = false
                }else {
                    cell.userRed.isHidden = true
                }
                
                
              if chatListArr[indexPath.row].is_online == 1 {
                    cell.userStats.isHidden = false
                    
                }else {
                    cell.userStats.isHidden = true
                }
                
            }
        
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatVC", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
       
        if chatListArr[indexPath.row].receiver ?? 0 != UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0{
            reciverId = chatListArr[indexPath.row].receiver ?? 0
        }else if chatListArr[indexPath.row].sender ?? 0 != UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0{
            reciverId = chatListArr[indexPath.row].sender ?? 0
        }
        
        let dict = ["sender":UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0,"receiver":reciverId,"reciverName": self.chatListArr[indexPath.row].full_name ?? "","userImg":self.chatListArr[indexPath.row].image ?? ""] as [String : Any]
           vc.userChatData = dict
           vc.modalPresentationStyle = .overCurrentContext
           self.timer.invalidate()
           self.present(vc, animated: true, completion: nil)

    }
}


class ChatListCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userStats: UIImageView!
    @IBOutlet weak var userRed: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
}
