//
//  ReviewedViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/09.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift


class ReviewedViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var specialtyName: UITextField!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var comment: UITextView!
    var pickerView: UIPickerView = UIPickerView()
    var cosmosCount: String = "2.5"
    
    let list: [String] = ["パン", "蕎麦"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specialtyName.delegate = self
        comment.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        // インプットビュー設定
        specialtyName.inputView = pickerView
        specialtyName.inputAccessoryView = toolbar
        
        // スター半分の評価ができるようにする
        cosmosView.settings.fillMode = .half
        cosmosView.didTouchCosmos = { rating in
            print(rating)
            self.cosmosCount = String(rating)
        }
    }
    
    // 決定ボタン押下
    @objc func done() {
        specialtyName.endEditing(true)
        specialtyName.text = "\(list[pickerView.selectedRow(inComponent: 0)])"
    }

    @IBAction func addbtn(_ sender: Any) {
        let realm = try! Realm()
        let review = Review()
        review.specialtyName = specialtyName.text!
//        cosmosView.didTouchCosmos = { rating in
//            cosmosCount = String(rating)
//        }
        review.evaluation = self.cosmosCount
        review.comment = comment.text!
        try! realm.write {
            realm.add(review)
        }
        self.navigationController?.popViewController(animated: true)
        
//        // Itemクラスのインスタンス作成
//        let newReview = Review()
//        // TextFieldの値を代入
//        newReview.specialtyName = specialtyName.text!
//        newReview.comment = comment.text!
//
//        // インスタンスをRealmに保存
//        do{
//            let realm = try Realm()
//            try realm.write({ () -> Void in
//                realm.add(newReview)
//            })
//        }catch{
//        }
//        // 画面を閉じる
//        self.dismiss(animated: true,completion: nil)
        
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.specialtyName.resignFirstResponder()
        return true
    }
    
    //キーボード以外の画面をタップでキーボード閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.comment.isFirstResponder) {
            self.comment.resignFirstResponder()
        }
    }
}

extension ReviewedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // ドラムロールの列数
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // ドラムロールの行数
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            /*
             列が複数ある場合は
             if component == 0 {
             } else {
             ...
             }
             こんな感じで分岐が可能
             */
            return list.count
        }
        
        // ドラムロールの各タイトル
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            /*
             列が複数ある場合は
             if component == 0 {
             } else {
             ...
             }
             こんな感じで分岐が可能
             */
            return list[row]
        }
        
        /*
        // ドラムロール選択時
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.textField.text = list[row]
        }
         */
    }

