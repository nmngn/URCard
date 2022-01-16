//
//  CardModel.swift
//  URCard
//
//  Created by Nam Ngây on 12/01/2022.
//

import Foundation
import RealmSwift

class SetCard: Object {
    @objc dynamic var IDSet = 0
    @objc dynamic var name = ""
}

class Card: Object {
    @objc dynamic var IDSet = 0
    @objc dynamic var IDCard = 0
    @objc dynamic var content = ""
}
