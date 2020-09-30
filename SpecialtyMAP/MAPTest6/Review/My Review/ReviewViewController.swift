//
//  ReviewViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/09.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var reviewList: Results<Review>!
    let cellHeigh:CGFloat = 125
    @IBOutlet weak var table: UITableView!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            table.delegate = self
            table.dataSource = self
            //let realm = try! Realm()
            // Realmからデータを取得
            do{
                let realm = try Realm()
                reviewList = realm.objects(Review.self)
            }catch{
            }

//            print(Realm.Configuration.defaultConfiguration.fileURL!)
//            todoItems = realm.objects(Review.self)
//            table.reloadData()
            
    // tableViewにカスタムセルを登録
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
            table.tableFooterView = UIView()
    }

//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            table.reloadData()
//        }

    // 画面が表示される直前にtableViewを更新
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
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
        
//        // カスタムセル内のプロパティ設定
//        if (reviewList[indexPath.row].specialtyName == "1") {
//            cell.specialtyName.text = "パン"
//        } else if (reviewList[indexPath.row].specialtyName == "2") {
//            cell.specialtyName.text = "蕎麦"
//        } else {
//            cell.specialtyName.text = reviewList[indexPath.row].specialtyName
//        }
        
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
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            let object = todoItems[indexPath.row]
//            cell.textLabel?.text = object.title
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//                deleteReview(at:indexPath.row)
//                table.reloadData()
//            }
//        }
//
//        func deleteReview(at index: Int) {
//            let realm = try! Realm()
//            print(Realm.Configuration.defaultConfiguration.fileURL!)
//            try! realm.write {
//                realm.delete(reviewList[index])
//            }
//        }
    
    // セルの削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            // Realm内のデータを削除
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.reviewList[indexPath.row])
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
    
    
}
