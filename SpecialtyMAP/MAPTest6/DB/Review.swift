//
//  Review.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/09.
//  Copyright © 2020 maimai. All rights reserved.
//

import Foundation
import RealmSwift

//レビュー
class Review:Object {
    
    //特産品名(String)
    @objc dynamic var specialtyName = ""
    //評価　※数字or星画像(double)
    @objc dynamic var evaluation = ""
    //コメント(String)
    @objc dynamic var comment = ""
    //作成日(Date)
    @objc dynamic var postDate = NSDate()
    //特産品コード
    //let speciality = List<Speciality>()
}
