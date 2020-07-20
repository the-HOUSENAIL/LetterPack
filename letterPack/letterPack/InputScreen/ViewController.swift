//
//  ViewController.swift
//  letterPack
//
//  Created by 今井 秀一 on 2020/07/02.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
//APIKitをインポート
//import APIKit


class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var toPostalCodeText: UITextField!
    @IBOutlet var toAddressText: UITextField!
    @IBOutlet var toNameText: UITextField!
    @IBOutlet var toTelText: UITextField!
    @IBOutlet var forPostalCodeText: UITextField!
    @IBOutlet var forAddressText: UITextField!
    @IBOutlet var forNameText: UITextField!
    @IBOutlet var forTelText: UITextField!
    @IBOutlet var contentsText: UITextField!
    @IBOutlet weak var toIncludeBuildingName: UITextField!
    @IBOutlet weak var forIncludeBuildingName: UITextField!
   
    //文字数制限
//    // 入力可能な最大文字数
//    let PCMaxLength: Int = 7
    
    //連絡先追加
    let request = CNSaveRequest()
    let contact = CNMutableContact()
    let contactStore = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キーボードを閉じる
        toPostalCodeText.delegate = self
        toAddressText.delegate = self
        toNameText.delegate = self
        toTelText.delegate = self
        forPostalCodeText.delegate = self
        forAddressText.delegate = self
        forNameText.delegate = self
        forTelText.delegate = self
        contentsText.delegate = self
        toIncludeBuildingName.delegate = self
        forIncludeBuildingName.delegate = self
        
        
        //連絡先への保存
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined, .restricted:
            contactStore.requestAccess(for: .contacts) { granted, error in
                if let error = error {
                    print(error)
                }
                if granted {
                    // アクセスを許可してもらえた時
                } else {
                    // アラートからアクセスの許可をしてもらえなかった時
                }
            }
        case .denied: break
            // 拒否されている場合
        case .authorized: break
            // すでにアクセスが許可されている場合
        default: break
            // それ以外の場合
        }
        
        
        // 連絡先を取得するクラスのインスタ巣を作成
        let store = CNContactStore.init()

        // 連絡帳の1つ1つのデータを収める空の配列 people を準備
        var people = [CNContact]()


        do {
            // 連絡先データベースからここでは苗字・名前・電話番号情報・住所情報を取得
            try store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor,
                                                                                  CNContactFamilyNameKey as CNKeyDescriptor,
                                                                                  CNContactPhoneNumbersKey as CNKeyDescriptor, CNPostalAddressStreetKey as CNKeyDescriptor])) {
                (contact, cursor) -> Void in

                // 電話番号が保持されている連絡先だったら
                if (!contact.phoneNumbers.isEmpty){

                   // 取得したデータをpeople に収める
                    people.append(contact)
                }
            }
        }
        catch{
            print("連絡先データの取得に失敗しました")
        }

        // peopleに取得した連絡先の数だけループ
        for humen in people{

            // 連絡先が保持している電話番号の数だけループ
            for number in humen.phoneNumbers {

                // 「電話：電話番号　名前：苗字 ま前」のフォーマットで連絡先データが出力される
                print("電話：\((number.value as CNPhoneNumber).stringValue) 名前：\(humen.familyName) \(humen.givenName)")
            }
        }
        
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        // ここに本処理を記述していく
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        
        let toAdd = toPostalCodeText.text
        let forAdd = forPostalCodeText.text
        
        // 文字数最大値を定義
        //var maxLength: Int = 0
        
        switch (textField.tag) {
        case 1:
            //        //宛先郵便番号&住所
//                    let toAddStartIndex = toAdd!.index(toAdd!.startIndex, offsetBy: 1) //開始位置 1
//                    let toEndIndex = toAdd!.index(toAddStartIndex, offsetBy: 3) // 長さ 3
//                    let toCount3 = toAdd![toAddStartIndex..<toEndIndex]
//                    let toAddStartIndex2 = toAdd!.index(toAdd!.startIndex, offsetBy: 5) //開始位置 5
//                    let toEndIndex2 = toAdd!.index(toAddStartIndex2, offsetBy: 4) // 長さ 4
//                    let toCount4 = toAdd![toAddStartIndex2..<toEndIndex2]
//                    print("\(toCount3)\(toCount4)")
//                    toPostalCodeText.text = "\(toCount3)\(toCount4)"
//                    let toIdx1 = toAdd!.firstIndex(of: " ")
//                    let toIdx2 = toAdd!.index(after:toIdx1!)
//                    //toAdd![idx2...] // "ext"
//                    print(toAdd![toIdx2...])
//                    toAddressText.text = String(toAdd![toIdx2...])
            
            // 郵便番号はハイフンなしでも取得可能です
            CLGeocoder().convertAddress(from: toAdd!) { (address, error) in
                if let error = error {
                    print(error)
                    return
                }
//                print(address?.administrativeArea) // → 東京都
//                print(address?.locality) // → 墨田区
//                print(address?.subLocality) // → 押上
                let addArea = address?.administrativeArea
                let addLocality = address?.locality
                let addCubLocality = address?.subLocality
                print ("\(addArea!)\(addLocality!)\(addCubLocality!)")
                self.toAddressText.text = "\(addArea!)\(addLocality!)\(addCubLocality!)"
            }
        case 2: break
        case 3: break
        case 4: break
        case 5:
                let toTelNumPos = toTelText.text!.replacingOccurrences(of:"-", with:"")
                toTelText.text = toTelNumPos
        case 6: //送り主郵便番号&住所
//                let forAddStartIndex = forAdd!.index(forAdd!.startIndex, offsetBy: 1) //開始位置 1
//                let forEndIndex = forAdd!.index(forAddStartIndex, offsetBy: 3) // 長さ 3
//                let forCount3 = forAdd![forAddStartIndex..<forEndIndex]
//                let forAddStartIndex2 = forAdd!.index(forAdd!.startIndex, offsetBy: 5) //開始位置 5
//                let forEndIndex2 = forAdd!.index(forAddStartIndex2, offsetBy: 4) // 長さ 4
//                let forCount4 = forAdd![forAddStartIndex2..<forEndIndex2]
//                print("\(forCount3)\(forCount4)")
//                forPostalCodeText.text = "\(forCount3)\(forCount4)"
//                let forIdx1 = forAdd!.firstIndex(of: " ")
//                let forIdx2 = forAdd!.index(after:forIdx1!)
//                //toAdd![idx2...] // "ext"
//                print(forAdd![forIdx2...])
//                forAddressText.text = String(forAdd![forIdx2...])
            
            // 郵便番号はハイフンなしでも取得可能です
            CLGeocoder().convertAddress(from: forAdd!) { (address, error) in
                if let error = error {
                    print(error)
                    return
                }
//                print(address?.administrativeArea) // → 東京都
//                print(address?.locality) // → 墨田区
//                print(address?.subLocality) // → 押上
                let addArea = address?.administrativeArea
                let addLocality = address?.locality
                let addCubLocality = address?.subLocality
                print ("\(addArea!)\(addLocality!)\(addCubLocality!)")
                self.forAddressText.text = "\(addArea!)\(addLocality!)\(addCubLocality!)"
            }
                
        case 7: break
        case 8: break
        case 9: break
        case 10:
                let forTelNumPos = forTelText.text!.replacingOccurrences(of:"-" , with:"")
                forTelText.text = forTelNumPos
        case 11: break
        default:
            break
        }

        return true
    }
    
    // キーボードを閉じる（UITextField以外の部分を押下時）
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // segueが動作することをViewControllerに通知するメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // segueのIDを確認して特定のsegueのときのみ動作させる
        if segue.identifier == "toLetterPackSegue" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? letterPackViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.outputToPC = self.toPostalCodeText.text
            next?.outputForPC = self.forPostalCodeText.text
            next?.outputToAdd = self.toAddressText.text!
            next?.outputToIBN = self.toIncludeBuildingName.text!
            next?.outputForAdd = self.forAddressText.text! + forIncludeBuildingName.text!
            next?.outputToName = self.toNameText.text
            next?.outputForName = self.forNameText.text
            next?.outputToTel = self.toTelText.text
            next?.outputForTel = self.forTelText.text
            next?.outputContents = self.contentsText.text
            
        }
        
        if segue.identifier == "toLetterPackPlusSegue" {
            // 2. 遷移先のViewControllerを取得
            let next = segue.destination as? letterPackPlusViewController
            // 3. １で用意した遷移先の変数に値を渡す
            next?.outputToPC = self.toPostalCodeText.text
            next?.outputForPC = self.forPostalCodeText.text
            next?.outputToAdd = self.toAddressText.text!
            next?.outputToIBN = self.toIncludeBuildingName.text!
            next?.outputForAdd = self.forAddressText.text! + forIncludeBuildingName.text!
            next?.outputToName = self.toNameText.text
            next?.outputForName = self.forNameText.text
            next?.outputToTel = self.toTelText.text
            next?.outputForTel = self.forTelText.text
            next?.outputContents = self.contentsText.text
            
        }
    }
    
    
    // address登録(宛先)
    @IBAction func saveAdd1(_ sender: UIButton) {
//        contact.givenName = "名前"
//        contact.familyName = "名字"
//        contact.phoneticGivenName = "なまえ"
//        contact.phoneticFamilyName = "みょうじ"

        //電話番号
//        contact.phoneNumbers = [
//            CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: "123-4567-8910")),
//            CNLabeledValue<CNPhoneNumber>(label: "カスタムのラベル", value: CNPhoneNumber(stringValue: "123-4567-8910"))]
        
        contact.givenName = toNameText.text!
        
        contact.phoneNumbers = [CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: toTelText.text!))]
        
        //住所
        let address = CNMutablePostalAddress()
        address.country = "日本"
        address.postalCode = self.toPostalCodeText.text!
        //        address.state = "愛知県"
        //        address.city = "名古屋市"
                address.street = self.toAddressText.text! + toIncludeBuildingName.text!
        

        contact.postalAddresses = [CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: address)]
        
        //保存
        request.add(contact, toContainerWithIdentifier: contactStore.defaultContainerIdentifier())

        do {
            try contactStore.execute(request)
        } catch {
            print(error)
        }
        
    }
    
    // address登録(依頼主)
    @IBAction func saveAdd2(_ sender: UIButton) {
        contact.givenName = forNameText.text!
                
        contact.phoneNumbers = [CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: forTelText.text!))]
                
                //住所
                let address = CNMutablePostalAddress()
                address.country = "日本"
                address.postalCode = self.forPostalCodeText.text!
        //        address.state = "愛知県"
        //        address.city = "名古屋市"
                address.street = self.forAddressText.text! + forIncludeBuildingName.text!
                

                contact.postalAddresses = [CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: address)]
                
                //保存
                request.add(contact, toContainerWithIdentifier: contactStore.defaultContainerIdentifier())

                do {
                    try contactStore.execute(request)
                } catch {
                    print(error)
                }
                
    }
    

    @IBAction func tapConfirmButton(_ sender: Any) {
//        // 4. 画面遷移実行
//        performSegue(withIdentifier: "toLetterPackSegue", sender: nil)
        
        let title = "レターパック選択"
        let message = "種類を選択してください"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "レターパックライト", style: .default, handler:{(action: UIAlertAction!) in
            
            //押下後画面遷移までの時間
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 0.5秒後に実行したい処理
             self.performSegue(withIdentifier: "toLetterPackSegue", sender: nil)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "レターパックプラス", style: .default, handler:{(action: UIAlertAction!) in
            
            //押下後画面遷移までの時間
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 0.5秒後に実行したい処理
             self.performSegue(withIdentifier: "toLetterPackPlusSegue", sender: nil)
            }
            
        }))
        // キャンセル
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }
}

// CLGeocoder(Contacts)地名出力時にエラーが出るのを回避
extension CLGeocoder {

    struct Address {
        var administrativeArea: String? // 都道府県 例) 東京都
        var locality: String? // 市区町村 例) 墨田区
        var subLocality: String? // 地名 例) 押上
    }

    func convertAddress(from postalCode: String, completion: @escaping (Address?, Error?) -> Void) {
        CLGeocoder().geocodeAddressString(postalCode) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let placemark = placemarks?.first {
                let location = CLLocation(
                    latitude: (placemark.location?.coordinate.latitude)!,
                    longitude: (placemark.location?.coordinate.longitude)!
                )
                 CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    guard let placemark = placemarks?.first, error == nil else {
                        completion(nil, error)
                        return
                    }
                    var address: Address = Address()
                    address.administrativeArea = placemark.administrativeArea
                    address.locality = placemark.locality
                    address.subLocality = placemark.subLocality
                    completion(address, nil)
                }
            }
        }
    }
}

