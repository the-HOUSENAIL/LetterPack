//
//  Maindata.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/04.
//  Copyright © 2020 maimai. All rights reserved.
//

import Foundation
import RealmSwift

//メイン
class Maindata: Object {
    
    //主キー
    //緯度
    @objc dynamic var latitude = Double()
    //経度
    @objc dynamic var longitude = Double()
    //番号
    @objc dynamic var number = Int16()
    //複合主キー
    @objc dynamic var compoundKey = String()
    
    @objc dynamic var shopNm = String()
    
    
    
    
    
    //都道府県コード
    let prefectures = List<Prefecture>()
    //特産品コード
    let speciality = List<Speciality>()
    //店舗コード
    let shop = List<Shop>()
    
    //作成日
    @objc dynamic var date = NSDate()


    override static func primaryKey() -> String? {
            return "compoundKey"
        }
}
