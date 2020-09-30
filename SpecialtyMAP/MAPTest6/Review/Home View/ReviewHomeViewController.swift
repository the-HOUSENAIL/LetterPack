//
//  ReviewHomeViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/11.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import RealmSwift

class ReviewHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var speList: Results<Speciality>!
    let cellHeigh:CGFloat = 125
    @IBOutlet weak var mainTableView: UITableView!
    
    var selectedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        // Realmからデータを取得
        do{
            let realm = try Realm()
            speList = realm.objects(Speciality.self)
        }catch{
        }
    
    // tableViewにカスタムセルを登録
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        mainTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        mainTableView.reloadData()
       print("Sample1ViewController Will Appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Sample1ViewController Will Disappear")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの内容を取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as! MainTableViewCell
        
        // カスタムセル内のプロパティ設定
        cell.speName.text = speList[indexPath.row].SpecialityName
        cell.speName.textAlignment = .center
        cell.speName.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.speList[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
        }
    }
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeigh
    }
    
    // Cell が選択された場合
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        selectedText = speList[indexPath.row].SpecialityName
        
        performSegue(withIdentifier: "toSubViewController",sender: nil)
        
        
        // [indexPath.row] から画像名を探し、UImage を設定
//        selectedImage = UIImage(named: imgArray[indexPath.row] as! String)
//        if selectedImage != nil {
//            // SubViewController へ遷移するために Segue を呼び出す
//            performSegue(withIdentifier: "toSubViewController",sender: nil)
//        }
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toSubViewController") {
            let subRHVC: SubReviewHomeViewController = (segue.destination as? SubReviewHomeViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
//            subVC.selectedImg = selectedImage
            
            subRHVC.text = selectedText
        }
    }

}
