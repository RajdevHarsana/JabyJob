//
//  ApiClass.swift
//  BleekSalon
//
//  Created by Ankur on 15/11/21.
//

import Foundation
import UIKit
import Alamofire
import TTGSnackbar

class ApiClass: NSObject{
    let (blurView,activityIndicatorView) = Helper.getLoaderViews()
//    const var pluse = 0
    static var apiCall = ApiClass()
    
//    private override init() {}
    
    var videoRequestCancel = Alamofire.SessionManager.default
    //    static var TokenDict = [String: String]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
     var alamoFireManager: SessionManager? = {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 500
        return manager
    }()
    
    
    
    
    func checkNetwork(){
        if !isInternetAvailable(){
            let snackbar = TTGSnackbar(message: "Internet is not available", duration: .long)
            snackbar.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            snackbar.show()
        }
    }
    
    
    func countryApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(BaeUrl, method: .get, parameters: paramters)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
//                        let countryModal = try JSONDecoder().decode(CountryModal.self, from: response.data!)
                        completion(response.result.value)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    
    func loginApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        let headers = ["Content-Type": "multipart/form-data"]
        alamoFireManager?.request(BaeUrl, method: .post, parameters: paramters,headers:[:])
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    completion(response.result.value)

                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    func registerApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        
        alamoFireManager?.request(BaeUrl, method: .post, parameters: paramters,headers:[:])
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
                        
                        let data = response.result.value as? [String:Any]
                        
                        if data?["status"] as? Int ?? 0 == 0 {
                            let snackbar = TTGSnackbar(message: data?["message"] as? String ?? "", duration: .short)
                            snackbar.show()
                        }else {
//                            let userModal = try JSONDecoder().decode(UserModal.self, from: response.data!)
                            completion(data)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    func verifyotpApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        let headers = ["Content-Type": "multipart/form-data"]
        alamoFireManager?.request(BaeUrl, method: .post, parameters: paramters,headers:[:])
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
                        print("userData",response.result.value)
                        //                        let countryModal = try JSONDecoder().decode(CountryModal.self, from: response.data!)
                        completion(response.result.value)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    func forgotPassApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        let headers = ["Content-Type": "multipart/form-data"]
        alamoFireManager?.request(BaeUrl, method: .post, parameters: paramters,headers:[:])
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
                        print("userData",response.result.value)
                        //                        let countryModal = try JSONDecoder().decode(CountryModal.self, from: response.data!)
                        completion(response.result.value)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    func updatedPassApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        let headers = ["Content-Type": "multipart/form-data"]
        alamoFireManager?.request(BaeUrl, method: .post, parameters: paramters,headers:[:])
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
                        print("userData",response.result.value)
                        //                        let countryModal = try JSONDecoder().decode(CountryModal.self, from: response.data!)
                        completion(response.result.value)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    
    func categoryApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        let headers = ["Content-Type": "multipart/form-data"]
        alamoFireManager?.request(BaeUrl, method: .get, parameters: paramters,headers:[:])
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
                        print("userData",response.result.value)
                        //                        let countryModal = try JSONDecoder().decode(CountryModal.self, from: response.data!)
                        completion(response.result.value)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    func skillApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        let headers = ["Content-Type": "multipart/form-data"]
        alamoFireManager?.request(BaeUrl, method: .post, parameters: paramters,headers:nil)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
                        print("userData",response.result.value)
                        //                        let countryModal = try JSONDecoder().decode(CountryModal.self, from: response.data!)
                        completion(response.result.value)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    
    func supcriptionApi(view:UIView,BaeUrl:String,paramters:JsonDict,completion:@escaping(_:Any)->Void) {
        
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
//        let headers = ["Content-Type": "multipart/form-data"]
        alamoFireManager?.request(BaeUrl, method: .post, parameters: paramters,headers:[:])
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch (response.result) {
                case .success( _):
                    do {
                        print("userData",response.result.value)
                let subscriptionModal = try JSONDecoder().decode(SubscriptionModal.self, from: response.data!)
                        completion(subscriptionModal)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    self.checkNetwork()
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
    
    
    func uploadVideoData(inputUrl:String,parameters:[String:Any],imageName: String,imageFile : Data,header:String,completion:@escaping(_:Any)->Void,processCompletion:@escaping(_:Float)->Void) {
        
       
        
        
        let headers : HTTPHeaders = [
            "Authorization":"Bearer " + header]

        alamoFireManager?.upload(multipartFormData: { (multipartFormData) in
        
                multipartFormData.append(imageFile, withName: imageName, fileName: "file.mp4", mimeType: "video/mp4")
    
                for key in parameters.keys{
                    let name = String(key)
                    if let val = parameters[name] as? String{
                        multipartFormData.append(val.data(using: .utf8)!, withName: name)
                    }
                }
    
            }, to:inputUrl,headers:headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
               
                upload.uploadProgress { progress in // main queue by default
                   DispatchQueue.global(qos: .background).async {
                       DispatchQueue.main.async {
                            processCompletion(Float(progress.fractionCompleted))
                        }
                    }
                }
                    upload.responseJSON { response in
                        completion(response.result.value)
                    }
                case .failure(let encodingError):
                    print("jhflsdhfjlk")
                    completion(encodingError)
                }
            }
        }
    
    func uploadPdfApi(inputUrl:String,parameters:[String:Any],pdfName:String,pdfFile:URL,header: String, completion:@escaping(_:Any)->Void,processCompletion:@escaping(_:Float)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer " + header
        ]

        alamoFireManager?.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(pdfFile, withName: pdfName, fileName: "pdf", mimeType: "application/pdf")

                    for key in parameters.keys{
                        let name = String(key)
                        if let val = parameters[name] as? String{
                            multipartFormData.append(val.data(using: .utf8)!, withName: name)
                        }
                    }

            }, to:inputUrl,headers: headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (Progress) in
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                 processCompletion(Float(Progress.fractionCompleted))
                             }
                         }
                    })

                    upload.responseJSON { response in
                        if let JSON = response.result.value {
                            completion(JSON)
                        }else{
                            completion(response.result.value)
                            print("jhflsdhfjlk")
                        }
                    }

                case .failure(let encodingError):
                    print("jhflsdhfjlk")
                    completion(encodingError)
                    //                   LoadingOverlay.shared.hideOverlayView()
                }

            }

        }
    
   
    func otpVerifie(inputUrl:String,parameters:[String:Any],completion:@escaping(_:Any)->Void) {
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
                
            }
        
        
    }
    func loginApi(inputUrl:String,parameters:[String:Any],completion:@escaping(_:Any)->Void) {
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
                
            }
    }

    func getUserTabBarProfile(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
//        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header,"Content-Type": "multipart/form-data"]

        alamoFireManager?.request(inputUrl, method: .get, parameters: parameters, headers: headers)
            .responseJSON { response in
//                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
            }
    }

func getUserProfile(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
    checkNetwork()
    
    addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
    let headers : HTTPHeaders = [
        "Authorization":"Bearer "+header,"Content-Type": "multipart/form-data"]

    alamoFireManager?.request(inputUrl, method: .get, parameters: parameters, headers: headers)
        .responseJSON { response in
            self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
            switch response.result
            {
            case .success(let json):
                let JSON = json as? [String:Any]
                completion(JSON)
            case .failure(let error):
                completion(error)
            }
        }
}
    
   
    func updateCatSkillApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func updateProfileApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header,]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    
    func editProfileUpdate(view:UIView,inputUrl:String,parameters:[String:Any],imageName: String,imageFile : UIImage,header:String,completion:@escaping(_:Any)->Void){
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header,
            "Content-Type": "multipart/form-data"
                 ]
        
        alamoFireManager?.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(imageData!, withName: imageName, fileName: "image.png", mimeType: "image/jpeg")
            multipartFormData.append(imageFile.jpegData(compressionQuality: 1)!, withName: imageName, fileName: "image.png", mimeType: "image/png")

            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }

        }, usingThreshold:UInt64.init(),
           to: inputUrl, //URL Here
           method: .post,
           headers: headers, //pass header dictionary here
           encodingCompletion: { (result) in

            switch result {
            case .success(let upload, _, _):
                print("the status code is :")

                upload.uploadProgress(closure: { (progress) in
                    print("something")
                })

                upload.responseJSON { response in
                    print("the resopnse code is : \(response.response?.statusCode)")
                    print("the response is : \(response)")
                }
                break
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                break
            }
        })
    }
    
    func uploadImageData(view:UIView,inputUrl:String,parameters:[String:Any],imageName: String,imageFile : UIImage,header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header,
            "Content-Type": "multipart/form-data"
                 ]
        //        LoadingOverlay.shared.showOverlay(view: UIApplication.shared.keyWindow!)
        let imageData = imageFile.jpegData(compressionQuality: 0.1)
        
        alamoFireManager?.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(imageData!, withName: imageName, fileName: "image.png", mimeType: "image/jpeg")
            
            
            
            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    multipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
            
        }, to:inputUrl,headers:headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print(Progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                    print(response.request)
                    if let JSON = response.result.value {
                        completion(JSON)
                        //                           LoadingOverlay.shared.hideOverlayView()
                    }else{
                        self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                        print(response.request)
                        print("jhflsdhfjlk")
                        //                           LoadingOverlay.shared.hideOverlayView()
                        //                           completion(response)
                    }
                }
                
            case .failure(let encodingError):
                print("jhflsdhfjlk")
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                completion(encodingError)
                //                   LoadingOverlay.shared.hideOverlayView()
            }
            
        }
        
    }
    func logoutApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    func videoListApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
         
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                print("JabyJobResponse",response)
                switch response.result
                {
                case .success(let josn):
                    let JSON = josn as? [String:Any]
                    print(JSON,"DKG")
                    
                    do {
                        let video = try? JSONDecoder().decode(HomeVideoModal.self, from: response.data!)
                        completion(video!)
                    }
                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    func changePasswordApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    func resoneApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
//                    let JSON = json as? [String:Any]
//                    completion(JSON)
                    
                    do {
                        let report = try? JSONDecoder().decode(ReportModal.self, from: response.data!)
                        completion(report!)
                    }

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    
    func submitReportApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    func saveVideoApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    
    func saveVideoListApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(_):
                    let saveVideo = try? JSONDecoder().decode(SaveVideoModal.self, from: response.data!)
                    
                    
                    completion(saveVideo!)
                    
                    

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    
    func contactusApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    func supportDetailApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    
    func socialLoginApi(view:UIView,inputUrl:String,parameters:[String:Any],completion:@escaping(_:Any)->Void) {
       
        checkNetwork()
//        let headers : HTTPHeaders = ["Content-Type" :"application/json"]
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        
        
        alamoFireManager?.request(baseUrl+"social-login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)

                case .failure(let error):
                    completion(error)
                }
            }
        
        
//        alamoFireManager?.request(inputUrl, method: .post, parameters: nil,encoding: JSONEncoding.default,headers:headers)
//            .responseJSON { response in
//                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView)
//                switch response.result
//                {
//                case .success(let json):
//                    let JSON = json as? [String:Any]
//                    completion(JSON)
//
//                case .failure(let error):
//                    completion(error)
//                }
//
//            }
    }
 
    
    func deleteVideoApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func deleteCVApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    
    func notificationsOnOff(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func notificationsList(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]

        alamoFireManager?.request(inputUrl, method: .get, parameters: parameters, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    
                    do {
                      
                let notification = try JSONDecoder().decode(NotificationModal.self, from: response.data!)
                        completion(notification)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func notificationsRemove(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)
                case .failure(let error):
                    completion(error)
                }
            }
    }
    
    func getOtherUserInfo(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(_):
                    
                    do {
                      
                let userInfo = try JSONDecoder().decode(OtherUserInfoModal.self, from: response.data!)
                        completion(userInfo)
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("Failed to load: \(error.localizedDescription)")
                    completion(error)
                }
            }
    }
    
    func getOtherUserInfo1(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer " + header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(_):
                    completion(response.result.value)

                case .failure(let error):
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
    }
    
    
    func demoVideoApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        checkNetwork()
        
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        let headers : HTTPHeaders = [
            "Authorization":"Bearer " + header]

        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(_):
                    completion(response.result.value)

                case .failure(let error):
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
    }
    
    func uploadChatPdfApi(inputUrl:String,parameters:[String:Any],pdfName:String,pdfFile:URL,header: String, completion:@escaping(_:Any)->Void,processCompletion:@escaping(_:Float)->Void) {
       

        alamoFireManager?.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(pdfFile, withName: pdfName, fileName: "pdf", mimeType: "application/pdf")

                    for key in parameters.keys{
                        let name = String(key)
                        if let val = parameters[name] as? String{
                            multipartFormData.append(val.data(using: .utf8)!, withName: name)
                        }
                    }
            }, to:inputUrl)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (Progress) in
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                 processCompletion(Float(Progress.fractionCompleted))
                             }
                         }
                    })

                    upload.responseJSON { response in
                        if let JSON = response.result.value {
                            completion(JSON)
                        }else{
                            completion(response.result.value)
                            print("jhflsdhfjlk")
                        }
                    }

                case .failure(let encodingError):
                    print("jhflsdhfjlk")
                    completion(encodingError)
                    //                   LoadingOverlay.shared.hideOverlayView()
                }

            }

        }
    
    
    
    func updateTokenApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
       
        checkNetwork()
        let headers : HTTPHeaders = [
            "Authorization":"Bearer " + header]
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                case .success(let json):
                    let JSON = json as? [String:Any]
                    completion(JSON)

                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    
    func getGuestUserId(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
//        let headers : HTTPHeaders = [
//            "Authorization":"Bearer "+header]
        checkNetwork()
         
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                   
                case .success(let josn):
                    let JSON = josn as? [String:Any]
//                    print(JSON,"DKG")
//                    do {
//                        let video = try? JSONDecoder().decode(HomeVideoModal.self, from: response.data!)
                        completion(JSON)
//                    }
                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    func nagadPaymentgatwayAPi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        let headers : HTTPHeaders = [
            "Authorization":"Bearer "+header]
        checkNetwork()
         
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                   
                case .success(let josn):
                    let JSON = josn as? [String:Any]
//                    print(JSON,"DKG")
//                    do {
//                        let video = try? JSONDecoder().decode(HomeVideoModal.self, from: response.data!)
                        completion(JSON)
//                    }
                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    
    func sendNagadPaymentStatusApi(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
//        let headers : HTTPHeaders = [
//            "Authorization":"Bearer "+header]
        checkNetwork()
         
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: URLEncoding.httpBody)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                   
                case .success(let josn):
                    let JSON = josn as? [String:Any]
//                    print(JSON,"DKG")
//                    do {
//                        let video = try? JSONDecoder().decode(HomeVideoModal.self, from: response.data!)
                        completion(JSON)
//                    }
                case .failure(let error):
                    completion(error)
                }
                
            }
    }
    
    
    
    func purchaseFreeTrail(view:UIView,inputUrl:String,parameters:[String:Any],header:String,completion:@escaping(_:Any)->Void) {
        
                let headers : HTTPHeaders = [
                    "Authorization":"Bearer "+header]
        
        checkNetwork()
         
        addLoaderToView(view: view,blurView:blurView ,activityIndicatorView:activityIndicatorView)
        alamoFireManager?.request(inputUrl, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseJSON { response in
                self.removeLoader(activityIndicatorView:self.activityIndicatorView,blurView:self.blurView, view: view)
                switch response.result
                {
                   
                case .success(let josn):
                    let JSON = josn as? [String:Any]
                   print(JSON,"FreeTrailDKG")
//                    do {
//                        let video = try? JSONDecoder().decode(HomeVideoModal.self, from: response.data!)
                        completion(JSON)
//                    }
                case .failure(let error):
                    completion(error)
                }
                
            }
    }
}

