//
//  ChatListVC.swift
//  JabyJob
//
//  Created by DMG swift on 28/01/22.
//

import UIKit
import MobileCoreServices
import SocketIO
import PDFKit
class UserMsg{
    var createdAt: String?
    var fileType: Int?
    var message: String?
    var receiver : Int?
    var sender : Int?
    var status : Int?
    var file : String?
    init(createdAt: String?,fileType: Int?,message: String?, receiver : Int?,sender : Int?, status : Int?,file : String?) {
        self.createdAt = createdAt
        self.message = message
        self.fileType = fileType
        self.receiver = receiver
        self.sender = sender
        self.status = status
        self.file = file
    }
}
var reciverIdPushNotifion = ""
var reciverNamePushNotifion = ""
var isfromNotification = false

class ChatVC: BaseViewController,UITextViewDelegate {
    @IBOutlet weak var tblChat:UITableView!
    @IBOutlet weak var viewTxt:UIView!
    @IBOutlet weak var txtUserInput:UITextView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var tblBottomConst: NSLayoutConstraint!
    @IBOutlet weak var lbltyping: UILabel!
    @IBOutlet weak var lblOnLine: UILabel!
    @IBOutlet weak var lbluserNmae: UILabel!
    @IBOutlet weak var docUploadPopUp: UIView!
    @IBOutlet weak var pdfImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var btnCall: UIButton!
    var placeholderLabel : UILabel!
    var roomId = String()
    var senderId = String()
    var reciverId = String()
    //    @IBOutlet weak var txtViewHeight:NSLayoutConstraint!
    let textViewMaxHeight: CGFloat = 50
    var msgData = [UserMsg]()
    let messageTextViewMaxHeight: CGFloat = 100
    fileprivate var pdfulr = String()
    fileprivate var reciverName = ""
    public var userChatData = [String:Any]()
    fileprivate var reciverImage = ""
    private var refreshControl = UIRefreshControl()
    private var page = 0
    var timer = Timer()
    var timer1 = Timer()
    private var isWating = false
    fileprivate var totalPage = 0
    fileprivate var guestUser = false
    var mainViewHeight = 0
    private var call = 0
    private var isTapOnDoc = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.btnCall.addTarget(self, action: #selector(didTapCall(_:)), for: .touchUpInside)
        
        let objToBeSent = false
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        dismiss(animated: false)
        
        mainViewHeight = Int(self.view.frame.size.height)
        docUploadPopUp.isHidden = true
        
        
        if isfromNotification == true {
            let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            
            if userid != 0 {
                self.btnCall.isHidden = false
                senderId = "\(userid)"
                reciverId = reciverIdPushNotifion
                reciverName = userChatData["reciverName"] as? String ?? ""
                self.updateChatDeatils()
            }else {
                self.btnCall.isHidden = true
                
              
                let uuid =  UIDevice.current.identifierForVendor?.uuidString
                let deviceToken =  UserDefaults.standard.value(forKey: "FCMToken") as? String ?? ""
                
                let params = ["device_token":deviceToken,"device_type":2,"device_id":uuid!] as JsonDict
                
                ApiClass().getGuestUserId(view: self.view, inputUrl: baseUrl+"get-user-id", parameters: params, header: "") { result in
                    print(result)
                    let dict = result as? JsonDict
                    self.guestUser = true
                  
                    self.senderId = "\(dict?["userId"] as? Int ?? 0)"
                    self.reciverId = reciverIdPushNotifion
                    self.reciverName = self.userChatData["reciverName"] as? String ?? ""
                    
                        self.updateChatDeatils()
                  
                }
                    
//                }
            }
        }else {
            
            let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            
            if userid != 0 {
                
                senderId = "\(userChatData["sender"] as? Int ?? 0)"
                reciverId = "\(userChatData["receiver"] as? Int ?? 0)"
                reciverName = userChatData["reciverName"] as? String ?? ""
                self.updateChatDeatils()
            }else {
                
                
                let uuid =  UIDevice.current.identifierForVendor?.uuidString
                let deviceToken =  UserDefaults.standard.value(forKey: "FCMToken") as? String ?? ""
                
                let params = ["device_token":deviceToken,"device_type":2,"device_id":uuid!] as JsonDict
                
                ApiClass().getGuestUserId(view: self.view, inputUrl: baseUrl+"get-user-id", parameters: params, header: "") { result in
                    print(result)
                    let dict = result as? JsonDict
                    self.guestUser = true
                    
                    self.senderId = "\(dict?["userId"] as? Int ?? 0)"
                    self.reciverId = "\(self.userChatData["receiver"] as? Int ?? 0)"
                    self.reciverName = self.userChatData["reciverName"] as? String ?? ""
                    
                    self.updateChatDeatils()
                }
            }
        }
    }
    
    func updateChatDeatils(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type your message"
        placeholderLabel.font = UIFont(name: "Montserrat-Regular", size: 14.0) //UIFont.italicSystemFont(ofSize: (txtUserInput.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtUserInput.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtUserInput.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtUserInput.text.isEmpty
        
        lbltyping.isHidden = true
        txtUserInput.delegate = self
        
        var dict = [String: Any]()
        dict = ["sender": senderId,"receiver":reciverId]
        
        
        SokectIoManager.sharedInstance.establishConnection()
        SokectIoManager.sharedInstance.connectToServerWithRoom(nickname: [dict])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.oldChatHistory(_:)), name: NSNotification.Name(rawValue: "all_message_coming"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.new_showChatMessage(_:)), name: NSNotification.Name(rawValue: "new_message_coming"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyPressed(_:)), name: NSNotification.Name(rawValue: "keyboardTypeing"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyPressedOff(_:)), name: NSNotification.Name(rawValue: "keyboardTypeingOff"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reciverUserDetails(_:)), name: NSNotification.Name(rawValue: "reciverDetail"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadMoreChat(_:)), name: NSNotification.Name(rawValue: "getMoreChat"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkOnLineStatus(_:)), name: NSNotification.Name(rawValue: "userOnlineOffLine"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getToalPageCount(_:)), name: NSNotification.Name(rawValue: "totalPage"), object: nil)
        
        txtUserInput.isScrollEnabled = false
        tblChat.register(UINib(nibName: "ReciverDoc", bundle: nil), forCellReuseIdentifier: "ReciverDoc")
        
        
        tblChat.register(UINib(nibName: "SenderDoc", bundle: nil), forCellReuseIdentifier: "SenderDoc")
        //        var dict = [String: Any]()
        //        dict = ["sender": senderId,"receiver":reciverId]
        SokectIoManager.sharedInstance.keyTypeingOff(dict: dict)
        
        
        let date = Date()
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        
        dict = ["sender": senderId,"receiver":reciverId,"message":"","filetype":0,"time":dateString]
        print(dict)
        SokectIoManager.sharedInstance.sendMessage(dict: dict)
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tblChat.refreshControl = refreshControl
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateCounting()
        })
        
        self.timer1 = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.updateCounting1()
        })
        
    }
    
    func updateCounting1(){
        
        var dict = [String:Any]()
        dict = ["receiver": reciverId] as JsonDict
        SokectIoManager.sharedInstance.checkReciverSataus(dict: dict)
        
    }
    
    func updateCounting(){
        var dict = [String:Any]()
        dict = ["sender": senderId] as JsonDict
        SokectIoManager.sharedInstance.checkUserStataus(dict: dict)
        
    }
    @objc private func didPullToRefresh(_ sender: Any) {
        
        if !isWating && page<totalPage - 1{
            self.isWating = false
            page = page + 1
            let dict = ["sender": senderId,"receiver":reciverId,"page":page] as [String : Any]
            SokectIoManager.sharedInstance.loadMoreChat(dict: dict)
            refreshControl.endRefreshing()
        }else {
            refreshControl.endRefreshing()
        }
    }
    
    
    @objc func getToalPageCount(_ notification: NSNotification) {
        
        let totalPage = notification.object as? Int ?? 0
        self.totalPage = totalPage
        
    }
    
    @objc func checkOnLineStatus(_ notification: NSNotification) {
        let dict = notification.object as? Int ?? 0
        if dict == 0 {
            lblOnLine.text = "Offline"
        }else {
            lblOnLine.text = "Online Now"
        }
    }
    @objc func loadMoreChat(_ notification: NSNotification) {
        
        let dict = notification.object as? [[String:Any]]
        //        _ = dict?.compactMap({ msgList in
        //            let date = msgList["createdAt"] as? String ?? ""
        //            let file = msgList["file"] as? String ?? ""
        //            let message = msgList["message"] as? String ?? ""
        //            let receiver = msgList["receiver"] as? Int ?? 0
        //            let sender = msgList["sender"] as? Int ?? 0
        //            let status = msgList["status"] as? Int ?? 0
        //            let fileType = msgList["fileType"] as? Int ?? 0
        //
        //            self.msgData.append(UserMsg.init(createdAt: date, fileType: fileType, message: message, receiver: receiver, sender: sender, status: status,file: file))
        //         })
        
        
        _ = dict?.compactMap({ msgList in
            let date1 = msgList["createdAt"] as? String ?? ""
            let file = msgList["file"] as? String ?? ""
            let message = msgList["message"] as? String ?? ""
            let receiver = msgList["receiver"] as? Int ?? 0
            let sender = msgList["sender"] as? Int ?? 0
            let status = msgList["status"] as? Int ?? 0
            let fileType = msgList["fileType"] as? Int ?? 0
            
            ///'Append messages according to data and time'
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            var convertedArray: [Date] = []
            
            //            var dateArray = ["2018-03-06", "2018-03-05"]
            //            for dat in dateArray {
            let date = dateFormatter.date(from: date1)
            if let date = date {
                convertedArray.append(date)
            }
            //            }
            
            let ready = convertedArray.sorted(by: { $0.compare($1) == .orderedAscending })
            // For Descending use .orderedDescending
            print(ready) //[2018-05-02 18:30:00 +0000, 2018-06-02 18:30:00 +0000]
            
            //            var newList = [String]()
            for date in ready {
                let dateformatter =  DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let convertDate = dateformatter.string(from: date)
                //                newList.append(convertDate)
                self.msgData.insert(UserMsg.init(createdAt: convertDate, fileType: fileType, message: message, receiver: receiver, sender: sender, status: status,file: file), at: 0)
                //                self.msgData.append(UserMsg.init(createdAt: convertDate, fileType: fileType, message: message, receiver: receiver, sender: sender, status: status,file: file))
            }
            //  print(newList)
            
        })
        
        
        self.tblChat.reloadData()
        //        msgData = msgData.reversed()
        if msgData.count > 0 {
            //            msgData = msgData.reversed()
            
            self.tblChat.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            
            
            ///           self.tblChat.scrollToRow(at: IndexPath(row: self.msgData.count - 1, section: 0), at: .bottom, animated: true)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "getMoreChat"), object: dict)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //       self.view.frame.origin.y = -150 // Move view 150 points upward
        viewBottom.constant = -10
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if self.view.frame.size.height >= 800{ //For bigger screens (X ,11)
            self.view.frame.size.height = keyboardFrame.size.height + 110
        } else {
            self.view.frame.size.height  = keyboardFrame.size.height + 110
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
        viewBottom.constant = 0
        
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        if isTapOnDoc == true {
            isTapOnDoc = false
            self.view.frame.size.height = CGFloat(mainViewHeight)
        }else {
            if self.view.frame.size.height >= 800{ //For bigger screens (X ,11)
//#MARK: ajeet comnt line no 366 for keyboard height 
                //self.view.frame.size.height = keyboardFrame.size.height
            } else {
                self.view.frame.size.height = CGFloat(mainViewHeight)
            }
        }
        
       
        
        //        self.tblBottomConst?.constant = 0.0
    }
    
    @IBAction override func didTapDismiss(_ sender: UIButton) {
        
        let objToBeSent = true
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        
        var dict = [String: Any]()
        dict = ["sender": senderId]
        SokectIoManager.sharedInstance.leaveChatRoom(dict: dict)
        SokectIoManager.sharedInstance.removeAllHandlers()
        timer.invalidate()
        timer1.invalidate()
        
        if isfromNotification == true {
            self.appDelegate.setRootToLogin(controllerVC: AfterLoingTabBarController(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
            isfromNotification = false
        }else if guestUser == true {
            self.guestUser = true
            self.dismiss(animated: true) {
                self.tabBarController?.selectedIndex = 0
            }
            self.dismiss(animated: true, completion: nil)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshChatList"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func reciverUserDetails(_ notification: NSNotification) {
        let data = notification.object as? [[String:Any]]
        //   print("UsaerData",notification.object as? [[String:Any]])
        lbluserNmae.text = data?[0]["username"] as? String ?? ""
        self.reciverImage =  data?[0]["image"] as? String ?? ""
        self.call = data?[0]["phone"] as? Int ?? 0
    }
    
    @objc func didTapCall(_ sender:UIButton){
        
        if let phoneCallURL = URL(string: "telprompt://\(call)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    @objc func keyPressedOff(_ notification: NSNotification) {
        lbltyping.isHidden = true
    }
    
    @objc func keyPressed(_ notification: NSNotification) {
        lbltyping.isHidden = false
        lbltyping.text = "Typing..."
    }
    
    @objc func oldChatHistory(_ notification: NSNotification) {
        self.msgData.removeAll()
        let dict = notification.object as? [[String:Any]]
        let data = dict?.reversed()
        _ = data?.compactMap({ msgList in
            let date1 = msgList["createdAt"] as? String ?? ""
            let file = msgList["file"] as? String ?? ""
            let message = msgList["message"] as? String ?? ""
            let receiver = msgList["receiver"] as? Int ?? 0
            let sender = msgList["sender"] as? Int ?? 0
            let status = msgList["status"] as? Int ?? 0
            let fileType = msgList["fileType"] as? Int ?? 0
            
            ///'Append messages according to data and time'
            let dateFormatter = DateFormatter()
            
            ///'Append messages according to data and time'
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            var convertedArray: [Date] = []
            
            //            var dateArray = ["2018-03-06", "2018-03-05"]
            //            for dat in dateArray {
            let date = dateFormatter.date(from: date1)
            if let date = date {
                convertedArray.append(date)
            }
            //            }
            
            let ready = convertedArray.sorted(by: { $0.compare($1) == .orderedSame })
            // For Descending use .orderedDescending
            print(ready) //[2018-05-02 18:30:00 +0000, 2018-06-02 18:30:00 +0000]
            
            // var newList = [String]()
            for date in ready {
                let dateformatter =  DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateformatter.timeZone = TimeZone(identifier: "UTC")
                let convertDate = dateformatter.string(from: date)
                self.msgData.append(UserMsg.init(createdAt: convertDate, fileType: fileType, message: message, receiver: receiver, sender: sender, status: status,file: file))
            }
//            self.msgData = self.msgData.reversed()
            //  print(newList)
            
        })
        
        
        if msgData.count > 0 {
            self.tblChat.reloadData()
            self.tblChat.scrollToRow(at: IndexPath(row: self.msgData.count - 1, section: 0), at: .bottom, animated: true)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "all_message_coming"), object: dict)
        }
    }
    
    @objc func new_showChatMessage(_ notification: NSNotification) {
        print("new message aaya")
        let dict = notification.object as? [[String:Any]]
        _ = dict?.compactMap({ msgList in
            let date = msgList["createdAt"] as? String ?? ""
            let file = msgList["file"] as? String ?? ""
            let message = msgList["message"] as? String ?? ""
            let receiver = msgList["receiver"] as? Int ?? 0
            let sender = msgList["sender"] as? Int ?? 0
            let status = msgList["status"] as? Int ?? 0
            let fileType = msgList["fileType"] as? Int ?? 0
            self.msgData.append(UserMsg.init(createdAt: date, fileType: fileType, message: message, receiver: receiver, sender: sender, status: status, file: file))
        })
        
        
        if msgData.count > 0 {
            self.tblChat.reloadData()
            self.tblChat.scrollToRow(at: IndexPath(row: self.msgData.count - 1, section: 0), at: .bottom, animated: true)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "new_message_coming"), object: dict)
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (range.location == 0 && text == " ") {
                    return false
                }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        var dict = [String: Any]()
        dict = ["sender": senderId,"receiver":reciverId]
        SokectIoManager.sharedInstance.keyTypeing(dict: dict)
        
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(ChatVC.getHintsFromTextField),
            object: txtUserInput)
        self.perform(
            #selector(ChatVC.getHintsFromTextField),
            with: txtUserInput,
            afterDelay: 1.0)
        return true
    }
    @objc func getHintsFromTextField(textField: UITextField) {
        print("Hints for textField: \(textField)")
        
        var dict = [String: Any]()
        dict = ["sender": senderId,"receiver":reciverId]
        SokectIoManager.sharedInstance.keyTypeingOff(dict: dict)
    }
    
    
    func textViewDidChange(_ textView: UITextView)
    {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        if textView.contentSize.height >= 33 {
            
            //              viewHeight.constant = 100
            if textView.contentSize.height >= 100{
                textView.isScrollEnabled = true
                viewHeight.constant = 100
            }else{
                if textView.contentSize.height < 34{
                    viewHeight.constant = 56
                }else{
                    viewHeight.constant = textView.contentSize.height + 20
                }
            }
        } else {
            viewHeight.constant = 56
            textView.contentSize.height = 56
            if textView.contentSize.height == 34{
                
            }
            
            textView.isScrollEnabled = true
        }
        
    }
    
    
    //    func textViewDidChangeSelection(_ textView: UITextView) {
    //        let fixedWidth = textView.frame.size.width
    //    textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //    let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        var newFrame = textView.frame
    //        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    //        var valeue = textView.text ?? ""
    //    txtUserInput.frame = newFrame;
    //    }
    //    func textViewDidChange(_ textView: UITextView) {
    //        let fixedWidth = textView.frame.size.width
    //    textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //    let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        var newFrame = textView.frame
    //        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    //    txtUserInput.frame = newFrame;
    //    }
    
}

extension ChatVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date1  = dateFormatterGet.date(from: string)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.timeZone = TimeZone(identifier: "UTC")
        dateFormatterPrint.dateFormat = "HH:mm"
        
        let date = dateFormatterPrint.string(from: date1!)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//
//        let date2 = dateFormatter.date(from: date)
//        dateFormatter.dateFormat = "h:mm a"
        
        let df = DateFormatter()
            df.dateFormat = "HH:mm"

            let date2 = df.date(from: date)
          if date2 != nil {
            df.dateFormat = "h:mm a"

            let time12 = df.string(from: date2!)
            print(time12)
            return time12
        }
           
        
//        if date2 != nil {
//            let Date12 = dateFormatter.string(from: date2!)
//            print("12 hour formatted Date:",Date12)
//        }
       
        
        print(date)
        return date
        //        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        //        return dateFormatterPrint.string(from: date!);
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if msgData.count > 0 {
            return msgData.count
        }else {
            return 0
        }
        
    }
    
    
    @objc func didTapPdf(_ sender:UITapGestureRecognizer){
        guard let getTag = sender.view?.tag else { return }
        //        PdfViewerVC
        if msgData[getTag].fileType ?? 0 == 1 {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PdfViewerVC") as! PdfViewerVC
            vc.pdfViewUrl = "https://jabyjobs.s3.us-east-2.amazonaws.com/" + (msgData[getTag].file ?? "")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    @objc func didTapLink(_ sender:UITapGestureRecognizer){
        guard let getTag = sender.view?.tag else { return }
        print("getTag")
        
        if let url = URL(string: msgData[getTag].message ?? "") {
            UIApplication.shared.open(url)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = getFormattedDate(string:msgData[indexPath.row].createdAt ?? "", formatter: "")
        if msgData[indexPath.row].sender == Int(senderId) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
            cell.lbltime.text = date
            if msgData[indexPath.row].fileType ?? 0 == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderDoc") as! SenderDoc
                cell.pdfImg.image = #imageLiteral(resourceName: "chatDoc")
                
                let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapPdf(_:)))
                cell.bgView.tag = indexPath.row
                cell.bgView.addGestureRecognizer(reportTap)
                
                return cell
            }else {
                if msgData[indexPath.row].message ?? "" != "" {
                    cell.lblMsg.text = msgData[indexPath.row].message ?? ""
                    if ((msgData[indexPath.row].message?.validURL) != nil) {
                        let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapLink(_:)))
                        cell.bgView.tag = indexPath.row
                        cell.bgView.addGestureRecognizer(reportTap)
                    }else {
                        
                    }
                }
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverCell") as! ReciverCell
            let date = getFormattedDate(string:msgData[indexPath.row].createdAt ?? "", formatter: "")
            cell.lblTime.text = date
            if msgData[indexPath.row].fileType ?? 0 == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverDoc") as! ReciverDoc
                
                let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapPdf(_:)))
                cell.bgView.tag = indexPath.row
                cell.bgView.addGestureRecognizer(reportTap)
                cell.pdfImg.image = #imageLiteral(resourceName: "chatDoc")
                return cell
            }else {
                if msgData[indexPath.row].message ?? "" != "" {
                    
                    cell.reciverImage.downloadImage(url: chatImageBaseUrl + reciverImage)
//                    cell.reciverImage.contentMode = .scaleAspectFit
                    
                    cell.lblMsg.text = msgData[indexPath.row].message ?? ""
                    
                    
                    if ((msgData[indexPath.row].message?.validURL) != nil) {
                        let reportTap = UITapGestureRecognizer(target: self, action: #selector(didTapLink(_:)))
                        cell.lblMsg.tag = indexPath.row
                        cell.lblMsg.addGestureRecognizer(reportTap)
                    }else {
                        
                    }
                }
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



extension ChatVC:UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate
{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        print(documentMenu)
    }
    func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.artBox)
    }
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        //        doc = urls[0]
        //        if contract == 0{
        ////            isDocContract = 1
        ////            imgContract.image = drawPDFfromURL(url: urls[0])
        //        }
        //        else{
        //            isDocIdentity = 1
        //            imgIdentity.image = drawPDFfromURL(url: urls[0])
        //        }
        
        
        guard let myURL = urls.first else {
            return
        }
        
        let thumbnailSize = CGSize(width: 120, height: 120)
        let thumbnail = generatePdfThumbnail(of: thumbnailSize, for: myURL, atPage: 0)
        
        if thumbnail == nil {
            self.pdfImage.image = #imageLiteral(resourceName: "google-docs")
        }else {
            self.pdfImage.image = thumbnail
        }
        
        
        docUploadPopUp.isHidden = false
        self.pdfulr = myURL.absoluteString
        txtUserInput.isUserInteractionEnabled = false
        let dict = ["user_id":senderId]
        ApiClass().uploadChatPdfApi(inputUrl: "http://3.143.123.23/api/upload-chat-file", parameters: dict, pdfName: "file", pdfFile: myURL, header: "") { result in
            print(result)
            
            let dict = result as? JsonDict
            self.txtUserInput.isUserInteractionEnabled = true
            if dict?["data"] as? String ?? "" != "" {
                let date = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                df.timeZone = TimeZone.current
                let dateString = df.string(from: date)
                
                let dict1 = ["sender": self.senderId,"receiver":self.reciverId,"message":" ","filetype":1,"time":dateString,"file":dict?["data"] as? String ?? ""] as [String : Any]
                print(dict)
                SokectIoManager.sharedInstance.sendMessage(dict: dict1)
                //                SokectIoManager.sharedInstance.getMessage()
            }
        } processCompletion: { process in
            print("Upload Progress: \(process * 100))")
            let value = process * 100
            //            self.progressBar.text = String(format: "%.0f", value) + "%"
            print("Upload Progress: \(process * 100))")
            self.progressBar.setProgress(process, animated: true)
            self.docUploadPopUp.isHidden = true
            
        }
    }
    
    @IBAction func didTapDoc(_ sender:UIButton){
        isTapOnDoc = true
        txtUserInput.resignFirstResponder()
        let types = [kUTTypePDF,"com.microsoft.word.doc" as CFString, "org.openxmlformats.wordprocessingml.document" as CFString]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        if #available(iOS 11.0, *) {
            importMenu.allowsMultipleSelection = true
        }
        
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true, completion: nil)
    }
    @IBAction func didTapSendMessage(_ sender:UIButton){
        var dict = [String: Any]()
        viewHeight.constant = 56
        
        if txtUserInput.text.trimmingCharacters(in: .whitespaces) == "" {
            
//            let alert = UIAlertController(title: "Alert", message: "Please type a messsage.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                case .default:
//                    print("default")
//
//                case .cancel:
//                    print("cancel")
//
//                case .destructive:
//                    print("destructive")
//
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
            return
        }else {
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.timeZone = TimeZone.current
            let dateString = df.string(from: date)
            
            dict = ["sender": senderId,"receiver":reciverId,"message":self.txtUserInput.text ?? "","filetype":0,"time":dateString]
            
            
            print(dict)
            SokectIoManager.sharedInstance.sendMessage(dict: dict)
            //            SokectIoManager.sharedInstance.getMessage()
            self.txtUserInput.text = ""
        }
    }
    
}


extension String {
    var validURL: Bool {
        get {
            let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self)
        }
    }
}

