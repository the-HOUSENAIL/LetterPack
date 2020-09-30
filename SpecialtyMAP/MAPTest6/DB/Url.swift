//
//  Url.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/16.
//  Copyright © 2020 maimai. All rights reserved.
//

import Foundation
import RealmSwift
//リンク
class Url:Object {
    //特産品コード
    let speciality = List<Speciality>()
    //URL(String)
    @objc dynamic var url = ""
    //作成日(Date)
    @objc dynamic var postDate = NSDate()
    
    /**
     プライマリキーのプロパティ名を返却します。
     
     - Returns: プライマリキーのプロパティ名
     */
//    override static func primaryKey() -> String? {
//        return "speciality"
//    }
    
}
