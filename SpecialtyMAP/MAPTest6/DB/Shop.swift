//
//  Shop.swift
//  MAPTest6
//
//  Created by 今井 秀一 on 2020/09/04.
//  Copyright © 2020 maimai. All rights reserved.
//

import Foundation
import RealmSwift

//　店舗
class Shop : Object {
    @objc dynamic var shopCode = Int16()
    @objc dynamic var shopName = String()
    @objc dynamic var shopAddr = String()
}
