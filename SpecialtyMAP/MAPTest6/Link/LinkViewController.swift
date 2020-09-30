//
//  LinkViewController.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/16.
//  Copyright © 2020 maimai. All rights reserved.
//

import UIKit
import RealmSwift

class LinkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var urlData = ["https://www.google.co.jp", "https://catch-questions.com", "https://www.yahoo.co.jp"]
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return urlData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            // セルに表示する値を設定する
    //        cell.textLabel!.text = array[indexPath.row]
            //cell.textLabel!.text = urlData[indexPath.row]
            // (1)Realmのインスタンスを生成する
            let realm = try! Realm()
            // (2)全データの取得
            let results = realm.objects(Url.self)
            cell.textLabel!.text = results[indexPath.row].url
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        var alertController = UIAlertController()
    //        alertController = UIAlertController(title:array[indexPath.row] ,message: "ここは下の段",preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: "OK",style: .default,handler: nil))
    //        present(alertController, animated: true)
            let realm = try! Realm()
            // (2)全データの取得
            let results = realm.objects(Url.self)
            
            var url = URL(string: "https://catch-questions.com")!
            if indexPath.section == 0 {
                url = URL(string: results[indexPath.row].url)!
            } else {
                url = URL(string: results[indexPath.row].url)!
            }
            
    //        let url = URL(string: "https://catch-questions.com")!
            if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
            UIApplication.shared.openURL(url)
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            // (1)Realmのインスタンスを生成する
            let realm = try! Realm()
            // (2)全データの取得
            let results = realm.objects(Url.self)
            // (3)取得データの確認
            print(results)
            
        }
    }

