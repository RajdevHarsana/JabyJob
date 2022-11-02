//
//  SocketIO.swift
//  JabyJob
//
//  Created by DMG swift on 25/04/22.
//

import Foundation
import `SocketIO`


class SokectIoManager:NSObject {
    static let sharedInstance = SokectIoManager()
    let manager : SocketManager
    var socket: SocketIOClient
//http://3.143.123.23:3390 //Live
//http://192.168.2.203:3390 //Local
    override init(){
        manager = SocketManager(socketURL: URL(string: "http://3.143.123.23:3390")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    func establishConnection() {
        socket.on(clientEvent: .connect) {data, ack in
          print("socket connected")
        }
//        socket.on("connect") {data, ack in
//          guard let cur = data[0] as? Double else { return }
//          self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data inds
//            self.socket.emit("update", ["amount": cur + 2.50])
//          }
//          ack.with("Got your currentAmount", "dude")
//        }
        socket.connect()
      }
      func closeConnection() {
        socket.disconnect()
      }
      func removeAllHandlers(){
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
      }
      func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
          return true
        }
        return false
      }
    
    
    //MARK:- Get Message Connection
      func connectToServerWithRoom(nickname: [Any]) {
        socket.emit("saveSocketId", with: nickname)
          self.getChatMessage()
          self.getUserDetails()
          self.getTotoalPage()
      }
    ///GetChatList
    func getChatList(nickname: [Any]) {
      socket.emit("getList", with: nickname)
      self.chatList()
        
//        self.getNewMessage()
    }
    
    func totalUnreadMsg(dict:[String:Any]) {
        socket.emit("totalUnreadMsg",with: [dict])
//        getMessage1()
        gettoalUnreadMsg()
       
      }
    
    
    func gettoalUnreadMsg() {
        socket.on("totalUnreadMsg") { ( dataArray, ack) -> Void in
          let dict = dataArray[0]
          print(dict)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "totalUnreadMsg"), object: dict, userInfo: nil)
        }
      }
    
    /////// endChatGetList
    
    
    func chatList() {
        socket.on("getList") { ( dataArray, ack) -> Void in
          let dict = dataArray[0] as? [String:Any] ?? [:]
          print(dict)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatList"), object: dict, userInfo: nil)
        }
      }
    func getChatMessage() {
        socket.on("saveSocketId") { ( dataArray, ack) -> Void in
          let dict = dataArray[0] as? [[String:Any]] ?? [[:]]
          print(dict)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "all_message_coming"), object: dict, userInfo: nil)
            
        }
      }
    
    func getUserDetails() {
        socket.on("userDetails") { ( dataArray, ack) -> Void in
          let dict = dataArray[0] as? [[String:Any]] ?? [[:]]
          print(dict)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reciverDetail"), object: dict, userInfo: nil)
        }
      }
     
    func sendMessage(dict:[String:Any]) {
        socket.emit("sendChatToServer",with: [dict])
//        getMessage1()
        getMessage()
       
      }
    
    func getMessage() {
       self.socket.off("sendChatToClient")
        socket.on("sendChatToClient") { ( dataArray, ack) -> Void in
          let dict = dataArray[0] as? [[String:Any]] ?? [[:]]
          print(dict)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new_message_coming"), object: dict, userInfo: nil)
         //  self.socket.off("sendChatToClient")
        }
      }
    
//    func getMessage1() {
////        self.socket.off("sendChatToClient1")
//        socket.on("sendChatToClient1") { ( dataArray, ack) -> Void in
//          let dict = dataArray[0] as? [[String:Any]] ?? [[:]]
//          print(dict)
//          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "new_message_coming"), object: dict, userInfo: nil)
////            self.socket.off("sendChatToClient1")
//            self.getMessage()
//        }
//      }
    
    func keyTypeing(dict:[String:Any]) {
        socket.emit("typing",with: [dict])
        getKeyTyping()
      }
    
    
   
    
    func getKeyTyping() {
        
        socket.on("typing") { ( dataArray, ack) -> Void in
            
            print("DKTypeing",dataArray)
            if dataArray[0] as? String ?? "" != "" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboardTypeing"), object: nil, userInfo: nil)
            }else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboardTypeingOff"), object: nil, userInfo: nil)
            }
//          let dict = dataArray[0] as? [[String:Any]] ?? [[:]]
//          print(dict)
          
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "keyboardTypeingOff"), object: nil, userInfo: nil)

      }
    
    func keyTypeingOff(dict:[String:Any]) {
        socket.emit("typingOff",with: [dict])
       getKeyTyping()
      }
    
    func leaveChatRoom(dict:[String:Any]) {
        socket.emit("saveLeaveTab",with: [dict])
//       getKeyTyping()
      }
    func checkUserStataus(dict:[String:Any]) {
        socket.emit("setStatus",with: [dict])
      }
    func checkReciverSataus(dict:[String:Any]) {
        socket.emit("getStatus",with: [dict])
        checkReciverOnlineOffLine()
      }
    
    func checkReciverOnlineOffLine() {

        socket.on("getStatus") { ( dataArray, ack) -> Void in
         let status = dataArray[0]
            print("DkgetStatus",dataArray)

//          let dict = dataArray[0] as? [[String:Any]] ?? [[:]]
          print(status)
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userOnlineOffLine"), object: status, userInfo: nil)
        }
      }
    func getTotoalPage() {

        socket.on("totalPage") { ( dataArray, ack) -> Void in
         let status = dataArray[0]
            print("totalPage",dataArray)

          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "totalPage"), object: status, userInfo: nil)
        }
      }
    
    
    func loadMoreChat(dict:[String:Any]){
        socket.emit("getMoreChat",with: [dict])
        getMoreChat()
    }
    func getMoreChat() {

        socket.on("getMoreChat") { ( dataArray, ack) -> Void in

            let dict = dataArray[0] as? [[String:Any]] ?? [[:]]
            print(dict)
            print("getMoreChat",dataArray)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getMoreChat"), object: dict, userInfo: nil)
            
        }
      }
    
    
    
}






extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
