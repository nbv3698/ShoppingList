//
//  WebViewController.swift
//  List
//
//  Created by Len on 2017/6/11.
//  Copyright © 2017年 Len. All rights reserved.
//

import UIKit

class WebViewController: UIViewController , UIWebViewDelegate , UITextFieldDelegate {
    var weblink: String!
    var webView: UIWebView!
    var myTextField :UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 取得螢幕的尺寸
        let fullScreenSize = UIScreen.main.bounds.size
        
        webView = UIWebView(frame: CGRect(
                x: 0, y: 30.0,
                width: fullScreenSize.width,
                height: fullScreenSize.height))
        webView.delegate = self
        
        // 建立 UITextField 顯示網址
        myTextField = UITextField(frame: CGRect(
            x: 0, y: 0,
            width: fullScreenSize.width, height: 30))
        
        myTextField.text = ""
        myTextField.backgroundColor = UIColor.init(
            red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        myTextField.clearButtonMode = .whileEditing
        myTextField.returnKeyType = .go
        myTextField.delegate = self
        self.view.addSubview(myTextField)
        
        view.addSubview(webView)
        if let url = URL(string: weblink!) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //取得目前網址
        let currentURL = webView.request?.mainDocumentURL
        myTextField.text = String(describing: currentURL!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
