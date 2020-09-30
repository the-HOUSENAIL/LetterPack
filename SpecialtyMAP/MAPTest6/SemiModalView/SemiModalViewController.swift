//
//  SemiModalViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/04.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import FloatingPanel
import WebKit

class SemiModalViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblStreetAddr: UILabel!
    var webView: WKWebView!
    
     let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = (delegate.nameValue)
        lblStreetAddr.text = (delegate.StreetAddrValue)
        lblDistance.text = (delegate.DistanceValue)
        
        // わかりやすくするため背景色だけ設定
        self.view.backgroundColor = UIColor.orange
        
        // デバイスの画面サイズを取得する
        let dispSize: CGSize = UIScreen.main.bounds.size
        //名前変更した方がいいかも？
        let height = Int(dispSize.height)
        let width = Int(dispSize.width)
        
        // ブラウザの表示領域を設定
        let rect = CGRect(x:0, y:230, width:width, height:height-230)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: rect, configuration: webConfiguration)

        // 読み込み開始、完了などの状態を取得できる様にする
        webView.navigationDelegate = self

        // back, forwardなどの操作メソッドを使用できる様にする
        webView.uiDelegate = self
        
        var url: String = "https://www.google.co.jp"

        url += "/search?q="
//        url += appDelegate.viewController.getTapStreetAddr()
        url += delegate.StreetAddrValue!
        url += "+"
        url += delegate.nameValue!
        
        // 日本語を含んだ文字列をURLやNSURLにするとnilになる対策
        let encodeUrl: String = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let webUrl = URL(string: encodeUrl)
        let myRequest = URLRequest(url: webUrl!)
        webView.load(myRequest)

        // インスタンスをビューに追加する
        self.view.addSubview(webView)
        
        // デバイスの画面サイズを取得する
//lblTitle.text = appDelegate.viewController.getTapPointTitle().description
//lblDistance.text = appDelegate.viewiewController.getTapDistance().description
//lblStreetAddr.text = "住所 \n" + appDelegate.viewiewController.getTapStreetAddr().description
        
//        lblTitle.text = "店舗名"
//        lblDistance.text = "距離"
//        lblStreetAddr.text = "住所"
    }
    
    
}
