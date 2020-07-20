//
//  letterPackViewController.swift
//  letterPack
//
//  Created by 今井 秀一 on 2020/07/03.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import Accounts
import PDFKit

class letterPackViewController: UIViewController {
    
    //
    let shareText = "シェアするよ"
    let shareUrl = NSURL(string: "https://www.apple.com/jp/")!
    
    var shereImage: UIImage?
    var pageSize = CGSize(width: 210 / 25.4 * 72, height: 297 / 25.4 * 72)
    
    
    
    // 1. 遷移先に渡したい値を格納する変数を用意する
    // 当て先郵便番号
    var outputToPC : String?
    var toPC1 = "0"
    var toPC2 = "0"
    var toPC3 = "0"
    var toPC4 = "0"
    var toPC5 = "0"
    var toPC6 = "0"
    var toPC7 = "0"

    
    // 依頼主郵便番号　※入力された文字列から一文字づつ取り出していれる
    var outputForPC : String?
    var forPC1 = "0"
    var forPC2 = "0"
    var forPC3 = "0"
    var forPC4 = "0"
    var forPC5 = "0"
    var forPC6 = "0"
    var forPC7 = "0"
    
    // 宛先住所設定
    var outputToAdd : String?
    var outputToIBN : String?
    var outputForAdd : String?
    
    //都道府県＋市区町村
    //番地
    //建物名
    var toAddress = "東京都~"
    var toIBN = ""
    var forAddress = "東京都~"
    
    
    // 氏名
    var outputToName : String?
    var outputForName : String?
    var toName = "山田太郎"
    var forName = "鈴木一郎"
    
    // TEL
    //※10桁と11桁で区切りを変更する設定をする事
    var outputToTel : String?
    var outputForTel : String?
    
    var toTel : String?
    var startToTel = "000"
    var middleToTel = "0000"
    var endToTel = "0000"

    var forTel : String?
    var startForTel = "000"
    var middleForTel = "0000"
    var endForTel = "0000"
    
    //品名
    var outputContents : String?
    var contents = "品名"
    
    
    //let imageLetterPack:UIImage! = UIImage(named:"letterPackLight")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //郵便番号を一文字づつ抽出
        //let toPC = outputToPC!.map { String($0) } // String -> [String]
        let toPC = outputToPC!.map { String($0) } // String -> [String]
//        print(toPC)
        
        let forPC = outputForPC!.map { String($0) } // String -> [String]
//        print(forPC)
        
//        toPC1 = toPC[1]
//        toPC2 = toPC[2]
//        toPC3 = toPC[3]
//        toPC4 = toPC[5]
//        toPC5 = toPC[6]
//        toPC6 = toPC[7]
//        toPC7 = toPC[8]

        toPC1 = toPC[0]
        toPC2 = toPC[1]
        toPC3 = toPC[2]
        toPC4 = toPC[3]
        toPC5 = toPC[4]
        toPC6 = toPC[5]
        toPC7 = toPC[6]
        
        forPC1 = forPC[0]
        forPC2 = forPC[1]
        forPC3 = forPC[2]
        forPC4 = forPC[3]
        forPC5 = forPC[4]
        forPC6 = forPC[5]
        forPC7 = forPC[6]
        
        toAddress = outputToAdd!
        toIBN = outputToIBN!
        forAddress = outputForAdd!
        
//        let toAddIdx1 = toAddress.firstIndex(of: "区")
//        let toAddIdx2 = toAddress.index(after:toAddIdx1!)
//        toAddress.text = String(toAddress[toAddIdx2...])
        
        
        toName = outputToName!
        forName = outputForName!
        
        
        //電話番号
        toTel = outputToTel!
        forTel = outputForTel!
        let startTelNum = toTel!.prefix(3) // 先頭３文字
        let middleTelNumStart = toTel!.index(toTel!.startIndex, offsetBy: 3 )
        let middleTelNumElevenEnd = toTel!.index(middleTelNumStart, offsetBy: 4 ) //11桁
        let middleTelNumTenEnd = toTel!.index(middleTelNumStart, offsetBy: 3 ) //10桁
        let middleTelNumEleven = toTel![middleTelNumStart..<middleTelNumElevenEnd] //11桁
        let middleTelNumTen = toTel![middleTelNumStart..<middleTelNumTenEnd] //10桁
        let endTelNum = toTel!.suffix(4) // 末尾4文字
        
        let forStartTelNum = forTel!.prefix(3) // 先頭３文字
        let forMiddleTelNumStart = forTel!.index(toTel!.startIndex, offsetBy: 3 )
        let forMiddleTelNumElevenEnd = forTel!.index(forMiddleTelNumStart, offsetBy: 4 ) //11桁
        let forMiddleTelNumTenEnd = forTel!.index(forMiddleTelNumStart, offsetBy: 3 ) //10桁
        let forMiddleTelNumEleven = forTel![forMiddleTelNumStart..<forMiddleTelNumElevenEnd] //11桁
        let forMiddleTelNumTen = forTel![forMiddleTelNumStart..<forMiddleTelNumTenEnd] //10桁
        let forEndTelNum = forTel!.suffix(4) // 末尾4文字
        
        startToTel = String(startTelNum)
        if (toTel?.count == 11) {
            middleToTel = String(middleTelNumEleven)
        } else if (toTel?.count == 10) {
            middleToTel = String(middleTelNumTen)
        } else {
            let title = "警告"
            let message = "入力が間違ってます"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // OKボタンを追加
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // UIAlertController を表示
            self.present(alert, animated: true, completion: nil)
        }
        endToTel = String(endTelNum)
        print(toTel!.count)
        
        startForTel = String(forStartTelNum)
        if (forTel?.count == 11) {
            middleForTel = String(forMiddleTelNumEleven)
        } else if (forTel?.count == 10) {
            middleForTel = String(forMiddleTelNumTen)
        } else {
            let title = "警告"
            let message = "入力が間違ってます"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // OKボタンを追加
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // UIAlertController を表示
            self.present(alert, animated: true, completion: nil)
        }
        endForTel = String(forEndTelNum)

        
        contents = outputContents!
        
        // 画面背景色を設定してみました
        self.view.backgroundColor = UIColor(red:0.99,green:0.81,blue:0.56,alpha:1.0)
    }
    
    // viewWillLayoutSubviews以降でないとsafeAreaInsetsは取得できない
    override func viewDidAppear(_ animated: Bool) {
        
        // 画面の横幅を取得
        // 以降、Landscape のみを想定
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        setup(sW: screenWidth, sH: screenHeight)
    }
    
   func setup(sW: CGFloat, sH: CGFloat){
    // letterPack画像の UIImage インスタンスを生成
        
    let imageletterPack:UIImage! = UIImage(named:"letterPackLight")
            
    // letterPack画像の幅・高さの取得
    let imageWidth = imageletterPack.size.width
    let imageHeight = imageletterPack.size.height
            
    // 描画領域を生成
    let rect = CGRect(x:0, y:0, width:imageWidth, height:imageHeight)
    
    //描写設定
    //文字サイズ設定
    let toPostalCodeFont = UIFont.boldSystemFont(ofSize: 30)
    let forPostalCodeFont = UIFont.boldSystemFont(ofSize: 10)
    // ToFor兼用住所
    let toAddressFont = UIFont.boldSystemFont(ofSize: 15)
    let forAddressFont = UIFont.boldSystemFont(ofSize: 15)
    
    let toNameFont = UIFont.boldSystemFont(ofSize: 15)
    let forNameFont = UIFont.boldSystemFont(ofSize: 15)
    
    let telFont = UIFont.boldSystemFont(ofSize: 15)
    
    let contentsFont = UIFont.boldSystemFont(ofSize: 20)
            
    
            
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Context 開始
    // 一番大きい画像サイズでContextを開く
            
    UIGraphicsBeginImageContext(imageletterPack.size)
    // Retinaで画像が粗い場合
    //UIGraphicsBeginImageContextWithOptions(imageEmmy.size, false, 0)
    
    // letterPackをUIImageのdrawInRectメソッドでレンダリング
    imageletterPack.draw(in: rect)
            
    
    
    // テキストの描画領域※画面の縦横で設定しているが、画像の縦横で出した方がいいかも
    let toPC1Rect  = CGRect(x:291, y:125, width:imageWidth-250, height:80)
    let toPC2Rect  = CGRect(x:326, y:125, width:imageWidth-250, height:80)
    let toPC3Rect  = CGRect(x:359, y:125, width:imageWidth-250, height:80)
    let toPC4Rect  = CGRect(x:395, y:125, width:imageWidth-250, height:80)
    let toPC5Rect  = CGRect(x:431, y:125, width:imageWidth-250, height:80)
    let toPC6Rect  = CGRect(x:464, y:125, width:imageWidth-250, height:80)
    let toPC7Rect  = CGRect(x:498, y:125, width:imageWidth-250, height:80)
    
    let toPostalCodeStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let toPostalCodeFontAttributes = [
        NSAttributedString.Key.font: toPostalCodeFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: toPostalCodeStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    toPC1.draw(in: toPC1Rect, withAttributes: toPostalCodeFontAttributes)
    toPC2.draw(in: toPC2Rect, withAttributes: toPostalCodeFontAttributes)
    toPC3.draw(in: toPC3Rect, withAttributes: toPostalCodeFontAttributes)
    toPC4.draw(in: toPC4Rect, withAttributes: toPostalCodeFontAttributes)
    toPC5.draw(in: toPC5Rect, withAttributes: toPostalCodeFontAttributes)
    toPC6.draw(in: toPC6Rect, withAttributes: toPostalCodeFontAttributes)
    toPC7.draw(in: toPC7Rect, withAttributes: toPostalCodeFontAttributes)
    
    //forPostalCode
    let forPC1Rect  = CGRect(x:223, y:420, width:imageWidth-250, height:80)
    let forPC2Rect  = CGRect(x:238, y:420, width:imageWidth-250, height:80)
    let forPC3Rect  = CGRect(x:253, y:420, width:imageWidth-250, height:80)
    let forPC4Rect  = CGRect(x:270, y:420, width:imageWidth-250, height:80)
    let forPC5Rect  = CGRect(x:286, y:420, width:imageWidth-250, height:80)
    let forPC6Rect  = CGRect(x:301, y:420, width:imageWidth-250, height:80)
    let forPC7Rect  = CGRect(x:316, y:420, width:imageWidth-250, height:80)
            
    let forPostalCodeStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let forPostalCodeFontAttributes = [
        NSAttributedString.Key.font: forPostalCodeFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: forPostalCodeStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    forPC1.draw(in: forPC1Rect, withAttributes: forPostalCodeFontAttributes)
    forPC2.draw(in: forPC2Rect, withAttributes: forPostalCodeFontAttributes)
    forPC3.draw(in: forPC3Rect, withAttributes: forPostalCodeFontAttributes)
    forPC4.draw(in: forPC4Rect, withAttributes: forPostalCodeFontAttributes)
    forPC5.draw(in: forPC5Rect, withAttributes: forPostalCodeFontAttributes)
    forPC6.draw(in: forPC6Rect, withAttributes: forPostalCodeFontAttributes)
    forPC7.draw(in: forPC7Rect, withAttributes: forPostalCodeFontAttributes)
    
    
    //toAddress
    let toAddressRect = CGRect(x:180, y:245, width:imageWidth-250, height:80)
    
    let toAddressStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let toAddressFontAttributes = [
        NSAttributedString.Key.font: toAddressFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: toAddressStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    toAddress.draw(in: toAddressRect, withAttributes: toAddressFontAttributes)
    
    //toIBN
    let toIBNRect = CGRect(x:180, y:275, width:imageWidth-250, height:80)
    
    let toIBNStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let toIBNFontAttributes = [
        NSAttributedString.Key.font: toAddressFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: toIBNStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    toIBN.draw(in: toIBNRect, withAttributes: toIBNFontAttributes)
    
    
    //forAddress
    let forAddressRect = CGRect(x:180, y:470, width:imageWidth-250, height:80)
    
    let forAddressStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let forAddressFontAttributes = [
        NSAttributedString.Key.font: forAddressFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: forAddressStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    forAddress.draw(in: forAddressRect, withAttributes: forAddressFontAttributes)
    
    //toName
    let toNameRect = CGRect(x:250, y:350, width:imageWidth-250, height:80)
    
    let toNameStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let toNameFontAttributes = [
        NSAttributedString.Key.font: toNameFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: toNameStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    toName.draw(in: toNameRect, withAttributes: toNameFontAttributes)
    
    //forName
    let forNameRect = CGRect(x:250, y:510, width:imageWidth-250, height:80)
    
    let forNameStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let forNameFontAttributes = [
        NSAttributedString.Key.font: forNameFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: forNameStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    forName.draw(in: forNameRect, withAttributes: forNameFontAttributes)
    
    //toTel
//    let toTelRect = CGRect(x:295, y:380, width:imageWidth-250, height:80)
    let startToTelRect = CGRect(x:290, y:380, width:imageWidth-250, height:80)
    let middleToTelRect = CGRect(x:360, y:380, width:imageWidth-250, height:80)
    let endToTelRect = CGRect(x:445, y:380, width:imageWidth-250, height:80)
    
    let toTelStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let toTelFontAttributes = [
        NSAttributedString.Key.font: telFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: toTelStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    startToTel.draw(in: startToTelRect, withAttributes: toTelFontAttributes)
    middleToTel.draw(in: middleToTelRect, withAttributes: toTelFontAttributes)
    endToTel.draw(in: endToTelRect, withAttributes: toTelFontAttributes)
    
    //forTel
    let startForTelRect = CGRect(x:290 , y:535 , width:imageWidth-250, height:80)
    let middleForTelRect = CGRect(x:360 , y:535 , width:imageWidth-250, height:80)
    let endForTelRect = CGRect(x:445 , y:535 , width:imageWidth-250, height:80)
    
    let forTelStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let forTelFontAttributes = [
        NSAttributedString.Key.font: telFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: forTelStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    startForTel.draw(in: startForTelRect, withAttributes: forTelFontAttributes)
    middleForTel.draw(in: middleForTelRect, withAttributes: forTelFontAttributes)
    endForTel.draw(in: endForTelRect, withAttributes: forTelFontAttributes)
    
    //contents
    let contentsRect = CGRect(x:175, y:620, width:imageWidth-250, height:80)
    
    let contentsStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
    let contentsAttributes = [
        NSAttributedString.Key.font: contentsFont,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.paragraphStyle: contentsStyle
    ]
    // テキストをdrawInRectメソッドでレンダリング
    contents.draw(in: contentsRect, withAttributes: contentsAttributes)
    
    // Context に描画された画像を新しく設定
    let newImage = UIGraphicsGetImageFromCurrentImageContext();
            
    // Context 終了
    UIGraphicsEndImageContext()
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            
            
    // UIImageView インスタンス生成
    let newImageView = UIImageView()
    newImageView.image = newImage
            
    let newImageWidth = newImage!.size.width
    let newImageHeight = newImage!.size.height
     
            
    // 画像サイズをスクリーン幅に合わせる, scaling
    let scale:CGFloat = sW / newImageWidth
     
    let newRect = CGRect(x: 0,
                            y: 0,
                            width: newImageWidth * scale,
                            height: newImageHeight * scale)
     
    // frame をCGRectで作った矩形に合わせる
    newImageView.frame = newRect
    
    //
    newImageView.isUserInteractionEnabled = true
    newImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.saveImage(_:))))
            
    // 画像の中心をスクリーンの中央あたりにする
    let adjust:CGFloat = 10
    newImageView.center = CGPoint(x: sW/2 ,
                                    y: sH/2 + adjust)
     
    // view に ImageView を追加する
    self.view.addSubview(newImageView)
    self.shereImage = newImageView.image
    
    }
    // セーブを行う
    @objc func saveImage(_ sender: UITapGestureRecognizer) {

        //タップしたUIImageViewを取得
        let letterPackImageView = sender.view! as! UIImageView
        // その中の UIImage を取得
        let targetImage = letterPackImageView.image!
        //保存するか否かのアラート
        let alertController = UIAlertController(title: "保存", message: "この画像を保存しますか？", preferredStyle: .alert)
        //OK
        let okAction = UIAlertAction(title: "OK", style: .default) { (ok) in
            //ここでフォトライブラリに画像を保存
            UIImageWriteToSavedPhotosAlbum(targetImage, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        //CANCEL
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default) { (cancel) in
            alertController.dismiss(animated: true, completion: nil)
        }
        //OKとCANCELを表示追加し、アラートを表示
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // 保存結果をアラートで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {

        var title = "保存完了"
        var message = "カメラロールに保存しました"

        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //
      @IBAction func lightShare() {
        
        //shareから遷移した際にシェアするアイテム
        let activityItems: [Any] = [shareText, shareUrl, shereImage!]
//        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: [LINEActivity(message: shareText), TwitterActivity(message: shareText)])
//        self.present(activityViewController, animated: true, completion: nil)

        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
//            UIActivity.ActivityType.postToFacebook,
//            UIActivity.ActivityType.postToTwitter,
//            UIActivity.ActivityType.message,
//            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.print
        ]

        activityVC.excludedActivityTypes = excludedActivityTypes

        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func funcPrint(_ sender: UIBarButtonItem) {
        
        let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "Print Job"
        printInfo.orientation = .portrait

        printController.printInfo = printInfo
        printController.printingItem = self.shereImage

        printController.present(animated: true, completionHandler: nil)
    }
}

