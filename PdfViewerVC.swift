//
//  PdfViewerVC.swift
//  JabyJob
//
//  Created by DMG swift on 13/04/22.
//

import UIKit
import WebKit

class PdfViewerVC: UIViewController {
    @IBOutlet weak var cvView: WKWebView!
    @IBOutlet weak var lbltitle: UILabel!
    
    var pdfViewUrl: String?
    var title1 = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if title1 != "" {
            lbltitle.text = title
        }
        
        let url = URL(string:pdfViewUrl!)
        cvView.load(URLRequest(url: url!))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapdismis(_sender:UIButton){
        self.dismiss(animated: true) {
            let objToBeSent = true
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
