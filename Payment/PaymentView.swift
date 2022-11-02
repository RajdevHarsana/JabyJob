//
//  PaymentView.swift
//  JabyJob
//
//  Created by DMG swift on 27/04/22.
//

import UIKit
import WebKit

class PaymentView: UIViewController,WKNavigationDelegate,UIWebViewDelegate, WKScriptMessageHandler, WKUIDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "Your11Payment"){
            print("\(message.body)")
        }
    }
    @IBOutlet weak var webView:WKWebView!
    
    let config = WKWebViewConfiguration()
    var popupView = WKWebView()
    var paymentUrl = ""
    var planID = 0
  
    fileprivate var isLoad = true
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if let response = navigationResponse.response as? HTTPURLResponse {
            
            if let response = response as? HTTPURLResponse {
                // Read all HTTP Response Headers
                
                print("All headers: \(response.url)")
                
                if self.isLoad == false {
                    self.payWithNagad(response.url!)
                }
                
            }
            
            
            
            
            if response.statusCode == 401 {
                // ...
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
    }
    
    override func willMove(toParent: UIViewController? ) {
        print("Something")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        self.isLoad = false
    }
    
    
    
    let contentController = WKUserContentController()
    @IBOutlet weak var webContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14.0, *) {
            webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            webView.configuration.preferences.javaScriptEnabled = true
            webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.loadHTMLString(description, baseURL: nil)
        let url = URL(string: paymentUrl)!
        //               webView.navigationDelegate = self
        webView.load(URLRequest(url : url))
    }
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func payWithNagad(_ paymentUrl: URL){
        let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        let params = ["plan_id":planID,"user_id":userid,"status":paymentUrl] as JsonDict
        
        ApiClass().sendNagadPaymentStatusApi(view: self.view, inputUrl: baseUrl+"get-nagad-status", parameters: params, header: "") { rsponse in
            print(rsponse)
            payment = true
            self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
        }
    }
}


