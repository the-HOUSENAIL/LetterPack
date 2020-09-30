//
//  SubReviewHomeViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/30.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift
 
class SubReviewHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    var reviewList: Results<Review>!
    let cellHeigh:CGFloat = 125
    @IBOutlet weak var tableView: UITableView!

    // 9. ViewControllerから受け取る文字列を入れる変数
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        // Realmからデータを取得
        do{
            let realm = try Realm()
//            reviewList = realm.objects(Review.self)
            if (text == "パン") {
                reviewList = realm.objects(Review.self).filter("specialtyName = 'パン'")
            } else if (text == "蕎麦") {
                reviewList = realm.objects(Review.self).filter("specialtyName = '蕎麦'")
            } else {
                reviewList = realm.objects(Review.self)
            }
            
        }catch{
        }
        
        // tableViewにカスタムセルを登録
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
            tableView.tableFooterView = UIView()
    }

        // 画面が表示される直前にtableViewを更新
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
            print("Sample1ViewController Will Appear")
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            print("Sample1ViewController Will Disappear")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // セルの内容を取得
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
    
    // カスタムセル内のプロパティ設定
        cell.specialtyName.text = reviewList[indexPath.row].specialtyName
        cell.specialtyName.textAlignment = .center
            cell.specialtyName.adjustsFontSizeToFitWidth = true
            
            cell.evaluation.text = reviewList[indexPath.row].evaluation
            cell.evaluation.textAlignment = .center
            cell.evaluation.adjustsFontSizeToFitWidth = true
            
            cell.comment.text = reviewList[indexPath.row].comment
            cell.comment.textAlignment = .left
            cell.comment.adjustsFontSizeToFitWidth = true
            return cell
        }
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeigh
    }
}

